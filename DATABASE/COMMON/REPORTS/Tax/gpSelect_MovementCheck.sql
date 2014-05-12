-- FunctiON: gpSelect_MovementCheck ()

DROP FUNCTION IF EXISTS gpSelect_MovementCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementCheck (
    IN inMovementId   Integer   , -- 
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (ParamText TVarChar, Param_Sale TVarChar, Param_Tax TVarChar--, Param_TaxCorrective TVarChar
             
              )  
AS
$BODY$
DECLARE vbDescId Integer;
DECLARE vbSaleId Integer;
DECLARE vbReturnInId Integer;
DECLARE vbTaxId Integer;
DECLARE vbTaxCorrectiveId Integer;
BEGIN

   
    SELECT DescId
    INTO vbDescId
    FROM Movement
    WHERE Id = inMovementId;
    
    IF vbDescId = zc_Movement_Sale()
    THEN
	vbSaleId:=inMovementId;
		
	SELECT COALESCE(MovementLinkMovement_Master.MovementChildId,0)
        INTO vbTaxId
        FROM Movement
	     LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                            ON MovementLinkMovement_Master.MovementId = Movement.Id
                                           AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
	WHERE Id = vbSaleId;
		
	/*SELECT COALESCE(MovementLinkMovement_Child.MovementId,0)
        INTO vbTaxCorrectiveId
        FROM Movement
             LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                            ON MovementLinkMovement_Child.MovementChildId = Movement.Id
                                           AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
        WHERE Movement.Id = vbTaxId*/ 
        vbTaxCorrectiveId := 0;  
	vbReturnInId := 0; 	

    ELSE IF vbDescId = zc_Movement_Tax()	
	 THEN
	     vbTaxId:=inMovementId;
	         
	     SELECT COALESCE(MovementLinkMovement_Master.MovementId,0) 
             INTO vbSaleId
             FROM Movement
		  LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                 ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                                AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
             WHERE Id = vbTaxId;   
	         
             /*SELECT COALESCE(MovementLinkMovement_Child.MovementId,0)
             INTO vbTaxCorrectiveId
             FROM Movement
                  LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                 ON MovementLinkMovement_Child.MovementChildId = Movement.Id
                                                AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
             WHERE Movement.Id = vbTaxId ;*/
 	     vbTaxCorrectiveId := 0;
             vbReturnInId := 0;    

	ELSE IF vbDescId = zc_Movement_TaxCorrective()
	     THEN
                 vbSaleId := 0; 
  
	         vbTaxCorrectiveId := inMovementId;
	   
	         SELECT COALESCE(MovementLinkMovement_Child.MovementChildId,0)
                 INTO vbTaxId
                 FROM Movement
                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                     ON MovementLinkMovement_Child.MovementId = Movement.Id
                                                    AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                 WHERE Movement.Id = vbTaxCorrectiveId;

                 SELECT COALESCE( MovementLinkMovement_Master.MovementChildId,0)
                 INTO vbReturnInId
                 FROM Movement
                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                     ON MovementLinkMovement_Master.MovementId = Movement.Id
                                                    AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                      WHERE  Movement.Id = vbTaxCorrectiveId;

                 /*SELECT COALESCE(MovementLinkMovement_Master.MovementId,0)
                 INTO vbSaleId
                 FROM Movement
                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                     ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                                    AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                 WHERE Id = vbTaxId; */
	     END IF; 	
             END IF; 
	END IF;
    
   
        RETURN QUERY
   
        SELECT 'Дата' ::TVarChar
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MovementDate_OperDatePartner.ValueData WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN  Movement.OperDate END) AS TVarChar )
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_Tax() THEN  Movement.OperDate END) AS TVarChar )
        FROM Movement
             LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                    ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                   AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
        WHERE Movement.Id In (vbSaleId, vbTaxId, vbTaxCorrectiveId)
       UNION  ALL
        SELECT 'Договор' ::TVarChar
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_Sale() THEN View_Contract_InvNumber.InvNumber WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN  View_Contract_InvNumber.InvNumber END)  AS TVarChar )
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_Tax() THEN  View_Contract_InvNumber.InvNumber END) AS TVarChar )
         --    , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN  View_Contract_InvNumber.InvNumber END) AS TVarChar )
        FROM Movement
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
        WHERE Movement.Id In (vbSaleId, vbTaxId, vbTaxCorrectiveId)
       UNION  ALL
        SELECT 'Юр.лицо' ::TVarChar
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_Sale() THEN Object_JuridicalTo.ValueData WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN Object_To.ValueData END)  AS TVarChar )
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_Tax() THEN  Object_To.ValueData END) AS TVarChar )
        FROM Movement
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END
             LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
 
             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                  ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
             LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId
         WHERE Movement.Id In (vbSaleId, vbTaxId, vbTaxCorrectiveId)
                
       UNION ALL
        SELECT 'Дата возврат' ::TVarChar
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN  Movement.OperDate END) AS TVarChar )
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementDate_OperDatePartner.ValueData END) AS TVarChar )
        FROM Movement
             LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                    ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                   AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
        WHERE Movement.Id In (vbTaxCorrectiveId, vbReturnInId) and vbReturnInId <> 0
       UNION ALL
        SELECT 'Договор возврат' ::TVarChar
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN View_Contract_InvNumber.InvNumber END) AS TVarChar )
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN View_Contract_InvNumber.InvNumber END) AS TVarChar )
        FROM Movement
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
        WHERE Movement.Id In (vbTaxCorrectiveId, vbReturnInId) and vbReturnInId <> 0
      UNION ALL
        SELECT 'Юр.лицо возврат' ::TVarChar
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN Object_To.ValueData END)  AS TVarChar )
             , CAST (MAX (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN Object_JuridicalTo.ValueData END) AS TVarChar )
        FROM Movement
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_From()  
             LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
 
             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                  ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
             LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId
         WHERE Movement.Id In (vbTaxCorrectiveId, vbReturnInId) and vbReturnInId <> 0

    
    ;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementCheck ( Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.05.14         *
  
*/

-- тест  
-- ID =  63798, 179697, 177551
--SELECT * FROM gpSelect_MovementCheck (inDocumentId:= 161850 , inSession:= zfCalc_UserAdmin());

--select * from gpSelect_MovementCheck(inmovementid := 177896  ,  inSession := '5');