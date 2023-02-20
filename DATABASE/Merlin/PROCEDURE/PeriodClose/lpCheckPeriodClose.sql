-- Проверка закрытия периода
-- Function: lpCheckPeriodClose()

DROP FUNCTION IF EXISTS lpCheckPeriodClose (TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheckPeriodClose(
    IN inOperDate         TDateTime , -- 
    IN inMovementId      Integer   , -- 
    IN inMovementDescId  Integer   , -- 
    IN inAccessKeyId     Integer   , -- 
    IN inUserId          Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$  
BEGIN

-- временно
 if inMovementDescId <> zc_Movement_ServiceItem() -- AND inMovementDescId <> zc_Movement_Service()
  then

     -- Проверка - период
     IF inOperDate < (CASE WHEN inMovementDescId = zc_Movement_ServiceItemAdd() THEN CURRENT_DATE ELSE CURRENT_DATE - INTERVAL '3 DAY' END)
        -- AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION 'Ошибка.Для пользователя <%> изменения в документе возможны с <%>.Дата документа = <%>.(<%>)(<%>)'
                       , lfGet_Object_ValueData_sh (inUserId) --, inUserId
                       , zfConvert_DateToString (CURRENT_DATE - INTERVAL '3 DAY')
                       , zfConvert_DateToString (inOperDate)
                       , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                       , inMovementId
                        ;
     END IF;


     -- Проверка - Пользователь
     IF NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = inUserId AND OB.DescId = zc_ObjectBoolean_User_Sign() AND OB.ValueData = TRUE)
        AND COALESCE (inUserId, -1) <> COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Insert()), -2)
        --AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ Автор = <%> не может корректироваться пользователем <%>.(<%>)(<%>)'
                       , lfGet_Object_ValueData ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Insert()))
                       , lfGet_Object_ValueData (inUserId)
                       , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                       , inMovementId
                        ;
     END IF;

 end if;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheckPeriodClose (TDateTime, Integer, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.04.16                                        * ALL
 25.02.14                        *
*/

-- тест
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 81241), Movement.* FROM Movement WHERE Id = 3091408 -- Бухгалтер ДНЕПР - Марухно А.В.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 81241), Movement.* FROM Movement WHERE Id = 3067578 -- Всем БН - Марухно А.В.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 300547), Movement.* FROM Movement WHERE Id = 3424050 -- Всем БН - Комелева А.Л.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 76913), Movement.* FROM Movement WHERE Id = 2802779  -- Начисления маркетинг - Земляная Л.Н
