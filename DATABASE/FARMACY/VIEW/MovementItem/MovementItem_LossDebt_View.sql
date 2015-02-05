-- View: Object_Unit_View

DROP VIEW IF EXISTS MovementItem_LossDebt_View;

CREATE OR REPLACE VIEW MovementItem_LossDebt_View AS 

       SELECT MovementItem.Id
            , MovementItem.MovementId
            , Object_Juridical.Id         AS JuridicalId
            , Object_Juridical.ValueData  AS JuridicalName
            , ObjectHistory_JuridicalDetails_View.OKPO
            , Object_JuridicalGroup.ValueData AS JuridicalGroupName
            , MovementItem.Amount

           , CASE WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountDebet
           , CASE WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountKredit

           , CASE WHEN MIFloat_Summ.ValueData > 0
                       THEN MIFloat_Summ.ValueData
                  ELSE 0
             END::TFloat AS SummDebet
           , CASE WHEN MIFloat_Summ.ValueData < 0
                       THEN -1 * MIFloat_Summ.ValueData
                  ELSE 0
             END::TFloat AS SummKredit

            , MIBoolean_Calculated.ValueData AS isCalculated

            , MovementItem.isErased       AS isErased
                  
       FROM  MovementItem 

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId 

            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Summ 
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                          ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()

   WHERE MovementItem.DescId  = zc_MI_Master();


ALTER TABLE MovementItem_LossDebt_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Ìàíüêî Ä.
 30.01.15                        * 
*/

-- òåñò
-- SELECT * FROM Movement_Income_View where id = 805
