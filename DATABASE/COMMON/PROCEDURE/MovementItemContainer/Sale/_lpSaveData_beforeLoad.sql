-- Function: _lpSaveData_beforeLoad (TDateTime, TDateTime)

DROP FUNCTION IF EXISTS _lpSaveData_beforeLoad (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION _lpSaveData_beforeLoad(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime   --
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbSessionId Integer;
  DECLARE vbSessiondDate TDateTime;

BEGIN
     vbSessionId:= COALESCE ((SELECT MAX (SessionId) FROM _testMI_afterLoad), 0) + 1;
     vbSessiondDate:= current_timestamp;

     --
     INSERT INTO _testMI_afterLoad (SessionId, SessiondDate, MovementId, DescId, StatusId, InvNumber, OperDate, OperDatePartner, FromId, ToId, ContractId, PaidKindId
                                  , MovementItemId, GoodsId, Amount, AmountPartner, Price, isErased)
        SELECT vbSessionId
             , vbSessiondDate
             , Movement.Id AS MovementId
             , Movement.DescId
             , Movement.StatusId
             , Movement.InvNumber
             , Movement.OperDate
             , CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MovementDate_OperDatePartner.ValueData ELSE Movement.OperDate END AS OperDatePartner
             , COALESCE (MovementLinkObject_From.ObjectId, 0) AS FromId
             , COALESCE (MovementLinkObject_To.ObjectId, 0) AS ToId
             , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
             , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId

             , MovementItem.Id AS MovementItemId
             , MovementItem.ObjectId AS GoodsId
             , MovementItem.Amount
             , COALESCE (CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MIFloat_AmountPartner.ValueData ELSE MovementItem.Amount END, 0) AS AmountPartner
             , COALESCE (MIFloat_Price.ValueData, 0) AS Price
             , MovementItem.isErased
        FROM Movement
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                          ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                         AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
             LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                    ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                   AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
--                                    AND MovementItem.isErased = FALSE
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()    

        WHERE Movement.DescId IN (zc_Movement_Tax(), zc_Movement_Sale(), zc_Movement_ReturnIn())
          AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
          -- AND Movement.OperDate BETWEEN inStartDate AND inEndDate
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   Ã‡Ì¸ÍÓ ƒ.
 17.05.14                                        *
*/
/*
CREATE TABLE _testMI_afterLoad(
   SessionId             Integer NOT NULL,
   SessiondDate          TDateTime NOT NULL,
   MovementId            Integer NOT NULL, 
   DescId                Integer NOT NULL, 
   StatusId              Integer NOT NULL, 
   InvNumber             TVarChar NOT NULL, 
   OperDate              TDateTime NOT NULL, 
   OperDatePartner       TDateTime NOT NULL, 
   FromId                Integer NOT NULL, 
   ToId                  Integer NOT NULL, 
   ContractId            Integer NOT NULL, 
   PaidKindId            Integer NOT NULL, 

   MovementItemId        Integer NOT NULL, 
   GoodsId               Integer NOT NULL,  
   Amount                TFloat  NOT NULL ,
   AmountPartner         TFloat  NOT NULL ,
   Price                 TFloat  NOT NULL ,
   isErased              Boolean NOT NULL ,

   CONSTRAINT fk_testMI_afterLoad_MovementItem FOREIGN KEY (MovementItemId) REFERENCES MovementItem (Id)
);

CREATE INDEX idx_testMI_afterLoad_SessionId ON _testMI_afterLoad (SessionId);
CREATE INDEX idx_testMI_afterLoad_SessionId_OperDate_DescId ON _testMI_afterLoad (SessionId, OperDate, DescId);
*/
-- ÚÂÒÚ
-- SELECT * FROM _lpSaveData_beforeLoad (inStartDate:= '01.04.2014', inEndDate:= '18.05.2014')

