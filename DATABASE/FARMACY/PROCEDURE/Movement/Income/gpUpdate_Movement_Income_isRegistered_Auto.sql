-- Function: gpUpdate_Movement_Income_isRegistered_Auto()

--DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_isRegistered_Auto (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_isRegistered_Auto (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_isRegistered_Auto(
    IN inDiscountExternalId  Integer ,   -- Программа
    IN inStartDate           TDateTime , --
    IN inEndDate             TDateTime , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
    vbUserId := inSession;

    -- сохранили свойство <Зарегистрирована (да/нет)> - Загружена приходная накладная от дистрибьютора в медреестр Pfizer МДМ 
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Registered(), Movement.Id, FALSE)
    FROM (SELECT DISTINCT Movement.Id
          FROM Movement
               LEFT JOIN MovementBoolean ON MovementBoolean.MovementId = Movement.Id
                                        AND MovementBoolean.DescId = zc_MovementBoolean_Registered()
               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                      AND MovementItem.DescId = zc_MI_Master()
                                      AND MovementItem.isErased = FALSE
                                      AND MovementItem.Amount <> 0
               INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                     ON ObjectLink_BarCode_Goods.ChildObjectId = MovementItem.ObjectId
                                    AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
               INNER JOIN Object AS Object_BarCode ON Object_BarCode.Id = ObjectLink_BarCode_Goods.ObjectId
                                                  AND Object_BarCode.isErased = FALSE
                                                  AND Object_BarCode.ValueData <> ''
               INNER JOIN ObjectLink AS ObjectLink_BarCode_Object
                                     ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                    AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                    AND ObjectLink_BarCode_Object.ChildObjectId = inDiscountExternalId
          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
            AND Movement.DescId   = zc_Movement_Income()
            AND Movement.StatusId = zc_Enum_Status_Complete()
            AND MovementBoolean.MovementId IS NULL
         ) AS Movement
   ;

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 09.07.20                                                                     *
 19.11.16                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Income_isRegistered_Auto (inStartDate:= '01.11.2016', inEndDate:= '30.11.2016', inSession:= '2')
