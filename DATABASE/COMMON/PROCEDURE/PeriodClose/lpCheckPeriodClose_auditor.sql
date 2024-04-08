-- Проверка закрытия периода
-- Function: lpCheckPeriodClose_auditor()

-- DROP FUNCTION IF EXISTS lpCheckPeriodClose_auditor (TDateTime, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpCheckPeriodClose_auditor (TDateTime, TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheckPeriodClose_auditor(
    IN inStartDate       TDateTime , -- Дата нач. периода
    IN inEndDate         TDateTime , -- Дата оконч. периода
    IN inMovementId      Integer   , -- 
    IN inMovementItemId  Integer   , -- 
    IN inObjectId        Integer   , -- 
    IN inUserId          Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$  
BEGIN
     -- !!!Только просмотр Аудитор!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 10597056)
     THEN
         -- 1
         IF inMovementId > 0
         THEN
             RAISE EXCEPTION 'Ошибка.Нет прав для проведения изменений %Документ <%> %№ <%> от <%>.'
                           , CHR (13)
                           , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                           , CHR (13)
                           , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                           , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                            ;
         END IF;

         -- 2
         IF inMovementItemId > 0
         THEN
             RAISE EXCEPTION 'Ошибка.Нет прав для проведения изменений %Элемент документа <%> %№ <%> от <%>.'
                           , CHR (13)
                           , (SELECT MovementDesc.ItemName FROM MovementItem JOIN Movement ON Movement.Id = MovementItem.MovementId JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE MovementItem.Id = inMovementItemId)
                           , CHR (13)
                           , (SELECT Movement.InvNumber FROM MovementItem JOIN Movement ON Movement.Id = MovementItem.MovementId WHERE MovementItem.Id = inMovementItemId)
                           , (SELECT zfConvert_DateToString (Movement.OperDate) FROM MovementItem JOIN Movement ON Movement.Id = MovementItem.MovementId WHERE MovementItem.Id = inMovementItemId)
                            ;
         END IF;

         -- 3
         IF inObjectId > 0
         THEN
             RAISE EXCEPTION 'Ошибка.Нет прав для проведения изменений %Справочник <%> % %.'
                           , CHR (13)
                           , (SELECT ObjectDesc.ItemName FROM Object JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId WHERE Object.Id = inObjectId)
                           , CHR (13)
                           , lfGet_Object_ValueData (inObjectId)
                            ;
         END IF;
         
         
         IF COALESCE (inStartDate, zc_DateStart()) < '01.01.2021'
         THEN
             RAISE EXCEPTION 'Ошибка.Данные недоступны за <%>.'
                           , zfConvert_DateToString (COALESCE (inStartDate, CURRENT_DATE))
                            ;
         END IF;

         IF COALESCE (inEndDate, zc_DateStart()) < '01.01.2021'
         THEN
             RAISE EXCEPTION 'Ошибка.Данные недоступны за <%>.'
                           , zfConvert_DateToString (COALESCE (inEndDate, CURRENT_DATE))
                            ;
         END IF;

     END IF;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.04.24                                        *
*/

-- тест
-- SELECT lpCheckPeriodClose_auditor (inStartDate:= OperDate, inEndDate:= OperDate, inMovementId:= Id, inMovementItemId:= DescId, inObjectId:= 0, inUserId:= 10597060), Movement.* FROM Movement WHERE Id = 3091408
