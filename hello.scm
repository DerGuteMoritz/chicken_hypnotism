; http://wiki.call-cc.org/eggref/4/awful
(use awful)

; http://wiki.call-cc.org/eggref/4/sxml-informal
(use sxml-transforms sxml-informal)

; http://wiki.call-cc.org/eggref/4/scss
; http://wiki.call-cc.org/eggref/4/jsmin
; http://wiki.call-cc.org/eggref/4/lowdown

(enable-sxml #t)

(let ((old-sxml->html (sxml->html)))
  (sxml->html (lambda (sxml)
                (old-sxml->html (pre-post-order* sxml informal-rules)))))

; Automatic Reload
(add-request-handler-hook!
   'reload-on-request
    (lambda (path handler)
         (reload-apps (awful-apps))
            (handler)))

(define send-page "/send")

(define-page (main-page-path)
  (lambda ()
    (set-page-title! "Contact")
    `((h1 "Contact")
      (informal
       (@ (method "POST") (action ,send-page))
       (fields
        (field string "name" label: "Your Name")
        (field string "email" label: "Your Mail Address")
        (field text "request" label: "Your Request")
        (field submit "Send Request")))))
  doctype: "<!DOCTYPE html>"
  method: '(GET))

(define-page send-page
  (lambda ()
    (set-page-title! "Thank you!")
    `((h1 "Thanks, " , ($ 'name "world") "!")))
  method: '(POST))
