DROP FUNCTION IF EXISTS gpGet_MovementFormClass (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementFormClass(
    IN inMovementId        Integer  , -- ключ Документа
   OUT outFormClass        TVarChar , --Класс формы для редактирования документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
BEGIN
    SELECT
        CASE Movement.DescId
            WHEN zc_Movement_Income() THEN zc_FormClass_Income()
            WHEN zc_Movement_ReturnOut() THEN zc_FormClass_ReturnOut()
            WHEN zc_Movement_Inventory() THEN zc_FormClass_Inventory()
            WHEN zc_Movement_Send() THEN zc_FormClass_Send()
            WHEN zc_Movement_Loss() THEN zc_FormClass_Loss()
            WHEN zc_Movement_Check() THEN zc_FormClass_Check()
            WHEN zc_Movement_Sale() THEN zc_FormClass_Sale()
            WHEN zc_Movement_SendPartionDate() THEN zc_FormClass_SendPartionDate()
        END
    INTO
        outFormClass
    FROM Movement
    WHERE Movement.Id = inMovementId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_MovementFormClass (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.05.15                         *
 28.04.15                         *
*/

-- тест
-- select * from gpGet_MovementFormClass(inMovementId := 14346050 ,  inSession := '3');