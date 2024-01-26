-- Function: gpUpdate_Movement_ReturnIn_PrintAuto_True()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnIn_PrintAuto_True (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnIn_PrintAuto_True(
    IN inMovementId       Integer , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbToId Integer;
    
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа продажи   
     SELECT Movement.OperDate                                   AS OperDate
          , MovementLinkObject_To.ObjectId                      AS ToId 
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)  AS ContractId
          INTO vbOperDate, vbToId, vbContractId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractFrom())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()  
     WHERE Movement.Id = inMovementId;

     --когда уже распечатали документы возврата в пакетной печати, проставляем признак = TRUE
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PrintAuto(), tmp.Id, TRUE)
     FROM 
          (SELECT Movement.Id 
           FROM Movement
                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                           ON MovementLinkObject_From.MovementId = Movement.Id
                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                          AND MovementLinkObject_From.ObjectId = vbToId
                INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                   AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractFrom())      
                          AND MovementLinkObject_Contract.ObjectId = vbContractId 
           WHERE Movement.OperDate = vbOperDate
             AND Movement.DescId   = zc_Movement_ReturnIn()
             AND Movement.StatusId = zc_Enum_Status_Complete()
          ) AS tmp
     ;

     -- сохранили протокол
     --PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.01.24          *
*/

-- тест
--  