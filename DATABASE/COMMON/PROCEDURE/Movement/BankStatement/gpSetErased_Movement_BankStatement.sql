-- Function: gpSetErased_Movement_BankStatement (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_BankStatement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_BankStatement(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_BankStatement());


     /*IF (SELECT StatusId FROM Movement WHERE Id = inMovementId) = zc_Enum_Status_Complete() THEN
        RAISE EXCEPTION 'По выписке сформированы документы.Удаление не возможно';
     END IF;*/


     -- Удаляем все Документы BankAccount
     PERFORM lpSetErased_Movement (inMovementId := Movement_BankAccount.Id
                                 , inUserId     := vbUserId)
     FROM Movement AS Movement_BankStatementItem
          JOIN Movement AS Movement_BankAccount ON Movement_BankAccount.ParentId = Movement_BankStatementItem.Id
     WHERE Movement_BankStatementItem.ParentId = inMovementId
       AND Movement_BankStatementItem.DescId = zc_Movement_BankStatementItem();

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     -- Удаляем элементы документа выписки
     PERFORM lpSetErased_Movement (inMovementId := Movement_BankStatementItem.Id
                                 , inUserId     := vbUserId)
     FROM Movement AS Movement_BankStatementItem
     WHERE Movement_BankStatementItem.ParentId = inMovementId
       AND Movement_BankStatementItem.DescId = zc_Movement_BankStatementItem();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 18.03.14                                        * add Удаляем элементы документа выписки
 13.03.14                                        * add Удаляем все Документы
 17.01.14                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_BankStatement (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
