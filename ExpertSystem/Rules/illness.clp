;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                DEFTEMPLATES & DEFFACTS                       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                          STARTUP                             ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule system-banner ""
=>
(assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                          QUESTIONS                           ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule determine-symptoms-types ""
	(start) 
	=>	
    (assert (UI-state (display WhatAilsThePatientQuestion)
					  (relation-asserted symptoms-types)
					  (valid-answers pain-in-one-place bad-mood other)))) 

(defrule determine-pain ""	
	(symptoms-types pain-in-one-place) 
	=>
	(assert (UI-state (display PainQuestion)
                      (relation-asserted pain-in-one-place)
                      (valid-answers head lungs stomach ear eye heart)))) 

(defrule determine-additional-symptomes ""	
	(symptoms-types bad-mood) 
	=>
	(assert (UI-state (display AdditionalSymptomsQuestion)
                      (relation-asserted additional-symptomes)
                      (valid-answers none food-poisoning cold flu))))

(defrule determine-other-symptomes ""	
	(symptoms-types other) 
	=>
	(assert (UI-state (display OtherSymptomsQuestion)
                      (relation-asserted other-symptomes)
                      (valid-answers skin overstrain hairs allergy))))

(defrule determine-high-fever ""
	(symptoms-types bad-mood)	
	(additional-symptomes flu) 
	=>
	(assert (UI-state (display HighFeverQuestion)
                      (relation-asserted high-fever)
                      (valid-answers yes no))))					 
					 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                          CONCLUSIONS                         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule neurologist ""
	(symptoms-types pain-in-one-place)
	(pain-in-one-place head)
     =>
	(assert (UI-state (display VisitToANeurologist)
					  (state final))))

(defrule pulmonologist ""
	(symptoms-types pain-in-one-place)
	(pain-in-one-place lungs)
     =>
	(assert (UI-state (display VisitToAPulmonologist)
					  (state final))))

 (defrule gastroenterologist ""
	(symptoms-types pain-in-one-place)
	(pain-in-one-place stomach)
     =>
	(assert (UI-state (display VisitToAGastroenterologist)
					  (state final))))
 
  (defrule laryngologist ""
	(symptoms-types pain-in-one-place)
	(pain-in-one-place ear)
     =>
	(assert (UI-state (display VisitToALaryngologist)
					  (state final)))) 
  
  (defrule ophthalmologist ""
	(symptoms-types pain-in-one-place)
	(pain-in-one-place eye)
     =>
	(assert (UI-state (display VisitToAnOphthalmologist)
					  (state final))))  
  
  (defrule cardiologist ""
	(symptoms-types pain-in-one-place)
	(pain-in-one-place heart)
     =>
	(assert (UI-state (display VisitToACardiologist)
					  (state final))))   
  
  (defrule dermatologist ""
	(symptoms-types other)
	(other-symptomes skin)
     =>
	(assert (UI-state (display VisitToADermatologist)
					  (state final))))
					    
  (defrule endocrinologist ""
	(symptoms-types other)
	(other-symptomes overstrain)
     =>
	(assert (UI-state (display VisitToAEndocrinologist)
					  (state final)))) 
					   
  (defrule trichologist ""
	(symptoms-types other)
	(other-symptomes hairs)
     =>
	(assert (UI-state (display VisitToATrichologist)
					  (state final))))  

  (defrule allergist ""
	(symptoms-types other)
	(other-symptomes allergy)
     =>
	(assert (UI-state (display VisitToAnAllergist)
					  (state final)))) 

  (defrule bad-mood ""
	(symptoms-types bad-mood)
	(additional-symptomes none)
     =>
	(assert (UI-state (display VitaminAndSportTherapy)
					  (state final)))) 
					   
  (defrule food-poisoning ""
	(symptoms-types bad-mood)
	(additional-symptomes food-poisoning)
     =>
	(assert (UI-state (display FoodPoisoningTherapy)
					  (state final))))	
					  				   
  (defrule flu ""
	(symptoms-types bad-mood)
	(additional-symptomes flu)
	(high-fever yes)
     =>
	(assert (UI-state (display FluTherapy)
					  (state final))))	
					  				  				   
  (defrule cold ""
	(symptoms-types bad-mood)
	(or
		(and
			(additional-symptomes flu)
			(high-fever no)
		)
		(additional-symptomes cold)	
	)
    =>
	(assert (UI-state (display ColdTherapy)
					  (state final))))  
   
   (defrule specialist ""
	(declare (salience -10))
    =>
	(assert (UI-state (display VisitToASpecialist)
                      (state final))))		
					  
					  			 					 				 	 			 					 			 	 	 		 			 				 		 		                   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                          GUI                                 ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
   
