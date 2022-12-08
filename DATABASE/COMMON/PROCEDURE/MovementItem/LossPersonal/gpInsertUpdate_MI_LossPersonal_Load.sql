-- Function: gpInsertUpdate_MI_LossPersonal_Load ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_LossPersonal_Load (Integer, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_LossPersonal_Load (Integer, TVarChar, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--+ InfoMoney + Unit + Position + PersonalServiceList + Branch


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_LossPersonal_Load(
    IN inMovementId              Integer   , -- ключ Документа
    IN inINN                     TVarChar  , -- ИНН Сотрудника 
    IN inAmount                  TFloat    , -- Сумма Корректировки 
    IN inInfoMoneyName           TVarChar  , --
    IN inUnitName                TVarChar  , --
    IN inPositionName            TVarChar  , --
    IN inPersonalServiceListName TVarChar  , --
    IN inBranchName              TVarChar  , --
    IN inSession                 TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbPersonalId Integer;
   DECLARE vbPositionId Integer;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbBranchId Integer;
   DECLARE vbPersonalServiceListId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossPersonal());

 --RAISE EXCEPTION 'Ошибка.%  % % % %', inInfoMoneyName, inUnitName, inPositionName, inPersonalServiceListName,inBranchName ;
 

     --находим Сотрудника
     SELECT Object_Personal_View.PersonalId
          , Object_Personal_View.UnitId
          , Object_Personal_View.BranchId
          , Object_Personal_View.PositionId
          , Object_PersonalServiceList.Id AS PersonalServiceListId
     INTO vbPersonalId, vbUnitId, vbBranchId, vbPositionId, vbPersonalServiceListId
     FROM ObjectString AS ObjectString_INN
          INNER JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectString_INN.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

     WHERE ObjectString_INN.DescId = zc_ObjectString_Member_INN() 
       AND  (TRIM (ObjectString_INN.ValueData)) =  (TRIM (inINN))
       AND UPPER (Object_Personal_View.UnitName) = UPPER (TRIM (inUnitName))
       AND UPPER (Object_Personal_View.BranchName) = UPPER (TRIM (inBranchName))
       AND UPPER (Object_Personal_View.PositionName) = UPPER (TRIM (inPositionName))
       --AND (UPPER (Object_PersonalServiceList.ValueData) = UPPER (TRIM (inPersonalServiceListName)) OR COALESCE (Object_PersonalServiceList.ValueData,'') = '')
       ;
     
     --проверка
     IF COALESCE (vbPersonalId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не найден Сотрудник ИНН %, должность %, подразделение %, Филиал %, ведомость %', inINN, inPositionName, inUnitName, inBranchName, inPersonalServiceListName;
     END IF;
   

     vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND UPPER (Object.ValueData) = UPPER (TRIM (inInfoMoneyName)) LIMIT 1); 
     --если у сотрудника не выбрана ведомость
     IF COALESCE(vbPersonalServiceListId,0) = 0
     THEN
         vbPersonalServiceListId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PersonalServiceList() AND UPPER (Object.ValueData) = UPPER (TRIM (inPersonalServiceListName)) LIMIT 1);
     END IF;
     
    -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_LossPersonal (ioId                    := 0
                                                     , inMovementId            := inMovementId            ::Integer
                                                     , inPersonalId            := vbPersonalId            ::Integer
                                                     , inAmount                := inAmount                ::TFloat
                                                     , inBranchId              := vbBranchId              ::Integer
                                                     , inInfoMoneyId           := vbInfoMoneyId           ::Integer                       --60101 Заработная плата
                                                     , inPositionId            := vbPositionId            ::Integer
                                                     , inPersonalServiceListId := vbPersonalServiceListId ::Integer
                                                     , inUnitId                := vbUnitId                ::Integer
                                                     , inComment               := NULL ::TVarChar
                                                     , inUserId                := vbUserId
                                                      );
     /*FROM ObjectString AS ObjectString_INN
          INNER JOIN lfSelect_Object_Member_findPersonal (inSession) AS lfSelect ON lfSelect.MemberId = ObjectString_INN.ObjectId
     WHERE ObjectString_INN.DescId = zc_ObjectString_Member_INN() 
       AND TRIM (ObjectString_INN.ValueData) = TRIM (inINN)
     LIMIT 1;    --на всякий случай
     */        


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.22         *
 05.12.22         *
*/

-- тест
-- 