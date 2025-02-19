
-- Function: gpUpdate_MI_WeighingProduction_BoxCalc()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingProduction_BoxCalc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingProduction_BoxCalc(
    IN inId                  Integer   , -- Ключ объекта <Документ>  
    IN inCountTare1          TFloat    , -- Количество
    IN inCountTare2          TFloat    , -- Количество
    IN inCountTare3          TFloat    , -- Количество
    IN inCountTare4          TFloat    , -- Количество
    IN inCountTare5          TFloat    , -- Количество
    IN inCountTare6          TFloat    , -- Количество
    IN inCountTare7          TFloat    , -- Количество
    IN inCountTare8          TFloat    , -- Количество
    IN inCountTare9          TFloat    , -- Количество
    IN inCountTare10         TFloat    , -- Количество
    IN inBoxWeight1          TFloat    , -- Вес
    IN inBoxWeight2          TFloat    , -- Вес
    IN inBoxWeight3          TFloat    , -- Вес
    IN inBoxWeight4          TFloat    , -- Вес
    IN inBoxWeight5          TFloat    , -- Вес
    IN inBoxWeight6          TFloat    , -- Вес
    IN inBoxWeight7          TFloat    , -- Вес
    IN inBoxWeight8          TFloat    , -- Вес
    IN inBoxWeight9          TFloat    , -- Вес
    IN inBoxWeight10         TFloat    , -- Вес
    IN inRealWeight          TFloat    , -- 
   OUT outNettoWeight        TFloat    ,
   OUT outBoxWeightTotal     TFloat    ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId         Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
     vbUserId := lpGetUserBySession (inSession);
 
     outBoxWeightTotal := (COALESCE (inCountTare1,0) * inBoxWeight1
                         + COALESCE (inCountTare2,0) * inBoxWeight2
                         + COALESCE (inCountTare3,0) * inBoxWeight3
                         + COALESCE (inCountTare4,0) * inBoxWeight4
                         + COALESCE (inCountTare5,0) * inBoxWeight5
                         + COALESCE (inCountTare6,0) * inBoxWeight6
                         + COALESCE (inCountTare7,0) * inBoxWeight7
                         + COALESCE (inCountTare8,0) * inBoxWeight8
                         + COALESCE (inCountTare9,0) * inBoxWeight9
                         + COALESCE (inCountTare10,0) * inBoxWeight10) ::TFloat;
            
     outNettoWeight := (COALESCE (inRealWeight,0) - COALESCE (outBoxWeightTotal,0)) ::TFloat;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.02.25         *
*/

-- тест
--