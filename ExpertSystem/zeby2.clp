
;;;======================================================
;;;   Automotive Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a car.
;;;
;;;     CLIPS Version 6.3 Example
;;;
;;;     For use with the Auto Demo Example
;;;======================================================

;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))
   
;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""

  =>
  
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-number-of-missing-teeth ""
	 (start)
    =>	
    (assert (UI-state (display MissingTeethQuestion)
                     (relation-asserted missing-teeth)
                     (response 1 )
                     (valid-answers 1 2-6 7-wiecej uzebienie-resztkowe bezzebie))))

(defrule determine-cost ""
		(missing-teeth ?)
    =>

    (assert (UI-state (display CostQuestion)
                     (relation-asserted cost)
                     (response sredni )
                     (valid-answers maly sredni duzy))))  

(defrule determine-root ""	
	(declare (salience -1))
	(missing-teeth 1)
	(cost ?) =>
	(assert (UI-state (display RootQuestion)
                     (relation-asserted root)
                     (response Tak )
                     (valid-answers Tak Nie)))) 
					 	
(defrule determine-lack ""
	(or
		(and
			(missing-teeth 2-6|7-wiecej)
			(cost duzy|sredni)
		)
		(and
			(cost duzy|sredni)
			(missing-teeth 1)
			(root Nie)
			(implantation Nie)
		)
	)
    =>
    (assert (UI-state (display LackQuestion)
                     (relation-asserted lack)
                     (response miedzyzebowe )
                     (valid-answers miedzyzebowe wolnoskrzydlowe))))

(defrule determine-implantation ""
	(or
		(and
			(cost sredni)
			(missing-teeth 1)
			(root Nie)
		)
		(and
			(cost duzy)
			(missing-teeth 1)
			(root Nie)
			
			
		)
		(and
			(cost duzy)
			(missing-teeth 2-6|7-wiecej|uzebienie-resztkowe|bezzebie)
		)
	)
    =>
    (assert (UI-state (display ImplantationQuestion)
                     (relation-asserted implantation)
                     (response Tak )
                     (valid-answers Tak Nie))))

(defrule determine-strain ""

	(cost sredni|duzy)
	(missing-teeth 1)
	(root Nie)
    =>	
    (assert (UI-state (display StrainQuestion)
                     (relation-asserted strain)
                     (response male )
                     (valid-answers male duze))))

(defrule determine-arch-shape ""
	(and
		(cost sredni)
		(missing-teeth 2-6|7-wiecej)
		(lack wolnoskrzydlowe)
	)
		

    =>
	(assert (UI-state (display ArchShapeQuestion)
                     (relation-asserted arch-shape)
                     (response retencyjny )
                     (valid-answers retencyjny bez-retencji))))

(defrule determine-crown ""
	(missing-teeth uzebienie-resztkowe)
	(or 
		(cost sredni)
		(and 
			(cost duzy)
			(implantation Nie)
		)		
	)
	
    =>
    (assert (UI-state (display CrownQuestion)
                     (relation-asserted crown)
                     (response Nie )
                     (valid-answers Tak Nie))))

(defrule determine-teeth-location ""	
	(cost sredni)
	(missing-teeth 7-wiecej)
    =>
    (assert (UI-state (display LocationQuestion)
                     (relation-asserted teeth-location)
                     (response jednostronne )
                     (valid-answers jednostronne dwustronne))))
					 
;;; ***************************
;;; *  FINAL  *  CONCLUSIONS  *
;;; *************************** 

(defrule proteza-calkowita ""
	(missing-teeth  uzebienie-resztkowe|bezzebie)	
	(or
		(cost maly)
		(and
			(cost duzy|sredni)
			(implantation Nie)
		)
		(and 
			(missing-teeth bezzebie)
			(cost sredni)
		)
	)
     =>
	(assert (UI-state (display ProtezaCalkowita)(state final))))	
					 
(defrule proteza-czesciowa ""
	(cost maly)
	(missing-teeth  1|2-6|7-wiecej)
     =>
	(assert (UI-state (display ProtezaCzesciowa)(state final))))					 

(defrule korona-na-implancie ""
	(cost sredni|duzy)
	(implantation Tak)
	(missing-teeth  1)
	(root Nie)
     =>
	(assert (UI-state (display KoronaNaImplancie)(state final))))	
					 
(defrule wklad-korona-cyrkonowa ""
	(cost duzy)
	(missing-teeth  1)
	(root Tak)
     =>
	(assert (UI-state (display WkladKoronaCyrkonowa)(state final))))
					 	
(defrule wklad-korona-metal ""
	(cost sredni)
	(missing-teeth  1)
	(root Tak)
     =>
	(assert (UI-state (display WkladKoronaMetalowa)(state final))))			
					 
(defrule most-jednobrzezny-cyrkonowy ""
	(cost duzy)
	(missing-teeth  1)
	(strain male)
	(implantation Nie)
     =>
	(assert (UI-state (display MostJednobrzeznyCyrkonowy)(state final))))		
					 		
(defrule most-jednobrzezny-metalowy ""
	(cost sredni)
	(missing-teeth  1)
	(strain male)
	(implantation Nie)
     =>
	(assert (UI-state (display MostJednobrzeznyMetalowy)(state final))))				
					 
(defrule most-dwubrzezny-cyrkonowy ""
	(cost duzy)
	(or
		(and
			(missing-teeth  1)
			(strain duze)
		)
		(missing-teeth 2-6)		
	)
	
	(implantation Nie)
	(lack miedzyzebowe)
     =>
	(assert (UI-state (display MostDwubrze¿nyCyrkonowy)(state final))))		
					 
(defrule most-dwubrzezny-metalowy ""
	(cost sredni)
	(or
		(and
			(missing-teeth  1)
			(implantation Nie)
			(strain duze)
		)
		(missing-teeth 2-6|7-wiecej)
	)	
	(lack miedzyzebowe)
     =>
	(assert (UI-state (display MostDwubrze¿nyMetalowy)(state final))))

(defrule most-dwubrzezny-implant ""
	(implantation Tak)
	(cost duzy)	
	(or
		(and
			(lack miedzyzebowe|wolnoskrzydlowe)
			(missing-teeth 2-6|7-wiecej)		
		)
		(missing-teeth uzebienie-resztkowe)
	)
	
     =>

	(assert (UI-state (display MostDwubrze¿nyImplant)(state final))))		
					 
(defrule proteza-szkieletowa ""
	(cost sredni)	
	(arch-shape retencyjny)

	(or
		(missing-teeth  2-6)
		(and
			(missing-teeth  7-wiecej)
			(teeth-location dwustronne)
		)
	)
     =>
	(assert (UI-state (display ProtezaSzkieletowa)(state final))))

(defrule proteza-szkieletowa-zatrzaski ""
	(or
		(and
			(missing-teeth  2-6)
			(cost sredni)
			(lack wolnoskrzydlowe)
			(arch-shape bez-retencji)
		)
		(and
			(cost duzy)	
			(missing-teeth  2-6)
			(implantation Nie)	
		)
		(and
			(cost duzy)	
			(missing-teeth  7-wiecej)
			(implantation Nie)	
			(lack miedzyzebowe|wolnoskrzydlowe)
		)
		(and
			(cost sredni)
			(missing-teeth  7-wiecej)
			(lack wolnoskrzydlowe)
			(arch-shape bez-retencji)
			(teeth-location dwustronne)
		)
	)
     =>
	(assert (UI-state (display ProtezaSzkieletowaZatrzaski)
                      (state final)
                     )))

	(defrule proteza-szkieletowa-rygiel ""
	(cost sredni)	
	(missing-teeth  7-wiecej)	
	(teeth-location jednostronne)
     =>
	(assert (UI-state (display ProtezaSzkieletowaRygiel)
                      (state final)
                     )))	
					 
(defrule proteza-ovd ""
	(cost sredni|duzy)	
	(missing-teeth  uzebienie-resztkowe)
	(crown Nie)
     =>
	(assert (UI-state (display ProtezaOvd)
                      (state final)
                     ))) 		
					 
(defrule proteza-caklowita-lokatory ""
	(cost duzy|sredni)	
	(missing-teeth  bezzebie)
	(implantation Tak)
     =>
	(assert (UI-state (display ProtezaCalkowitaLokatory)
                      (state final)
                     )))	
(defrule proteza-teleskopy ""
	(cost sredni|duzy)	
	(missing-teeth  uzebienie-resztkowe)
	(crown Tak)
     =>

	(assert (UI-state (display ProtezaTeleskopy)
                      (state final)
                     )))
					 
(defrule wizyta-u-specjalisty ""
	(declare (salience -10))
     =>
	(assert (UI-state (display WizytaUSpecjalisty)
                      (state final)
                     )))					 					 				 	 			 					 			 	 	 		 			 				 		 		                   
;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

	(declare (salience 5))
   
   (UI-state (id ?id))
   
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
             
   =>
   
   (modify ?f (current ?id)
              (sequence ?id ?s))
   
   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
                      
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))
   
   ?f <- (next ?id)

   (state-list (sequence ?id $?))
   
   (UI-state (id ?id)
             (relation-asserted ?relation))
                   
   =>
      
   (retract ?f)

   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
     
   (UI-state (id ?id) (response ?response))
   
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))
   
   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
     
   (UI-state (id ?id) (response ~?response))
   
   ?f2 <- (UI-state (id ?nid))
   
   =>
         
   (modify ?f1 (sequence ?b ?id ?e))
   
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)
   
   (state-list (sequence ?id $?))
   
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
                
   =>
      
   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
      
   (assert (add-response ?id ?response)))   

(defrule handle-add-response

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id ?response)
                
   =>
      
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   
   (retract ?f1))   

(defrule handle-add-response-none

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id)
                
   =>
      
   (str-assert (str-cat "(" ?relation ")"))
   
   (retract ?f1))   

(defrule handle-prev

   (declare (salience 10))
      
   ?f1 <- (prev ?id)
   
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
                
   =>
   
   (retract ?f1)
   
   (modify ?f2 (current ?p))
   
   (halt))
   
