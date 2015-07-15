(in-package :cl-user)
(defpackage datafly-test.json
  (:use :cl
        :datafly
        :cl-test-more))
(in-package :datafly-test.json)

(plan 9)

(defvar *timestamp*
  (local-time:unix-to-timestamp 1360850770))

(is (encode-json `(:name "Eitaro" :status :registered :created-at ,*timestamp*))
    "{\"name\":\"Eitaro\",\"status\":\"registered\",\"createdAt\":1360850770}"
    "Property List")

(is (encode-json `((:name "Eitaro" :status :registered :created-at ,*timestamp*)
                   (:name "Tomohiro" :status :temporary :created-at ,(local-time:timestamp+ *timestamp* 1 :day))))
    "[{\"name\":\"Eitaro\",\"status\":\"registered\",\"createdAt\":1360850770},{\"name\":\"Tomohiro\",\"status\":\"temporary\",\"createdAt\":1360937170}]"
    "Property List")

(is (encode-json `((:name . "Eitaro") (:status . :registered) (:created-at . ,*timestamp*)))
    "{\"name\":\"Eitaro\",\"status\":\"registered\",\"createdAt\":1360850770}"
    "Association List")

(let* ((json
         (encode-json (alexandria:plist-hash-table `(:name "Eitaro" :status :registered :created-at ,*timestamp*))))
       (decoded (cl-json:decode-json-from-string json)))
  (is (cdr (assoc :name decoded)) "Eitaro")
  (is (cdr (assoc :status decoded)) "registered")
  (is (cdr (assoc :created-at decoded)) 1360850770))

(is (encode-json `((:name . "Eitaro") (:status . :registered) (:created-at . ,*timestamp*)
                                      (:settings . (("timezone" . "JST")))))
    "{\"name\":\"Eitaro\",\"status\":\"registered\",\"createdAt\":1360850770,\"settings\":{\"timezone\":\"JST\"}}"
    "Nested Association List")

(defclass std-user ()
  ((name :initarg :name)
   (status :initarg :status)
   (created-at :initarg :created-at)))

(defstruct struct-user
  name
  status
  created-at)

(is (encode-json (make-instance 'std-user :name "Eitaro" :status :registered :created-at *timestamp*))
    "{\"name\":\"Eitaro\",\"status\":\"registered\",\"createdAt\":1360850770}"
    "Standard object")
(is (encode-json (make-struct-user :name "Eitaro" :status :registered :created-at *timestamp*))
    "{\"name\":\"Eitaro\",\"status\":\"registered\",\"createdAt\":1360850770}"
    "Structure object")

(finalize)
