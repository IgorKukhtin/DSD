-- Function: gpUpdate_Movement_OrderExternal_Deferred_byIncome()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_Deferred_byIncome (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_Deferred_byIncome(
    IN inMovementId          Integer              , -- ключ Документа приход
    IN inSession             TVarChar               -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbJuridicalId     Integer;
  DECLARE vbToId            Integer;
  DECLARE vbContractId      Integer;
  DECLARE vbOperDate        TDateTime;
  DECLARE vbOrderId         Integer;
  DECLARE vbisDeferred      Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
     vbUserId:= inSession;
     
--raise notice 'Value 03: <%', CURRENT_TIMESTAMP;       

     -- Определить от кого, кому, договор, дата аптеки
     SELECT MLO_From.ObjectId                     AS JuridicalId
          , MLO_To.ObjectId                       AS ToId
          , COALESCE (MLO_Contract.ObjectId, 0)   AS ContractId
          , Movement.OperDate                     AS OperDate
     INTO vbJuridicalId, vbToId, vbContractId, vbOperDate
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From 
                                       ON MLO_From.MovementId = inMovementId 
                                      AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MLO_To
                                       ON MLO_To.MovementId = inMovementId
                                      AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementLinkObject AS MLO_Contract
                                       ON MLO_Contract.MovementId = inMovementId
                                      AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()
     WHERE Movement.Id = inMovementId 
       AND Movement.DescId = zc_Movement_Income();

--raise notice 'Value 03: <%', CURRENT_TIMESTAMP;       
   
     -- Снять заказ из отложенных, привязанный к этому приходу
     SELECT MLM.MovementChildId 
          , COALESCE (MB_Deferred.ValueData, False) AS isDeferred
          INTO vbOrderId, vbisDeferred
     FROM MovementLinkMovement AS MLM 
          LEFT JOIN MovementBoolean AS MB_Deferred
                 ON MB_Deferred.MovementId = MLM.MovementChildId
                AND MB_Deferred.DescId = zc_MovementBoolean_Deferred()
     WHERE MLM.descid = zc_MovementLinkMovement_Order()
       AND MLM.MovementId = inMovementId; 
    
     -- в найденной заявке меняем статус Отложенн на НЕ отложен
     IF COALESCE (vbOrderId, 0) <> 0 AND vbisDeferred = TRUE 
     THEN
         -- Cохранили свойство <Отложен> НЕТ
         PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), vbOrderId, FALSE);
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (vbOrderId, vbUserId, FALSE);
     END IF;

--raise notice 'Value 03: <%', CURRENT_TIMESTAMP;       
     
     -- снимается ОТЛОЖЕН у ВСЕХ заявок с этой точки до даты прихода
     PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), Movement.Id, FALSE)            -- сохранили свойство Отложен  НЕТ
           , lpInsert_MovementProtocol (Movement.Id, vbUserId, FALSE)                                     -- сохранили протокол
     FROM  Movement
             
          INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                     ON MovementBoolean_Deferred.MovementId = Movement.Id
                                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                    AND MovementBoolean_Deferred.ValueData = TRUE

          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                       AND MovementLinkObject_From.ObjectId = vbJuridicalId

          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                       AND MovementLinkObject_To.ObjectId = vbToId
                                       
          INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                       AND MovementLinkObject_Contract.ObjectId = vbContractId

          -- свойство юр.лица - Исключение - заказ всегда "Отложен"
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Deferred
                                  ON ObjectBoolean_Deferred.ObjectId = vbJuridicalId
                                 AND ObjectBoolean_Deferred.DescId = zc_ObjectBoolean_Juridical_Deferred()                                     
          
     WHERE Movement.DescId   = zc_Movement_OrderExternal()
       AND Movement.OperDate <= vbOperDate
       AND Movement.OperDate >= vbOperDate - INTERVAL '1 MONTH'
       AND Movement.StatusId in (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
       AND COALESCE (ObjectBoolean_Deferred.ValueData, FALSE) = FALSE
       ;

--raise notice 'Value 03: <%', CURRENT_TIMESTAMP;       

    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> ', inSession;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.08.17         * 
*/

-- тест
    
select * from gpUpdate_Movement_OrderExternal_Deferred_byIncome(inMovementId := 28341986 ,  inSession := '3');