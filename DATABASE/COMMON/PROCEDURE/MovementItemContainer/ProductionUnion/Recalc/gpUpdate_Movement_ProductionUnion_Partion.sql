-- Function: gpUpdate_Movement_ProductionUnion_Partion (TDateTime, TDateTime, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Partion (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Partion(
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inFromId       Integer,    -- 
    IN inToId         Integer,    -- 
    IN inSession      TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ProductionUnion_Partion());

    -- пересчет Рецептур, временно захардкодил
    PERFORM lpUpdate_Object_Receipt_Total (Object.Id, zfCalc_UserAdmin() :: Integer) FROM Object WHERE DescId = zc_Object_Receipt();
    -- пересчет Рецептур, временно захардкодил
    PERFORM lpUpdate_Object_Receipt_Parent (0, 0, 0);


    -- Пересчет
    PERFORM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate  := TRUE
                                                     , inStartDate := inStartDate
                                                     , inEndDate   := inEndDate
                                                     , inFromId    := inFromId
                                                     , inToId      := inToId
                                                     , inUserId    := zc_Enum_Process_Auto_PartionClose() -- vbUserId
                                                      );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.07.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate:= TRUE, inStartDate:= '01.07.2015', inEndDate:= '19.07.2015', inFromId:= 8448, inToId:=8458 , inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ деликатесов + Склад База ГП
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate:= TRUE, inStartDate:= '01.07.2015', inEndDate:= '19.07.2015', inFromId:= 8447, inToId:=8458 , inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ колбасный   + Склад База ГП
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate:= TRUE, inStartDate:= '01.08.2017', inEndDate:= '31.08.2017', inFromId:= 8449, inToId:=8458 , inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ с/к         + Склад База ГП
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate:= TRUE, inStartDate:= '01.08.2017', inEndDate:= '31.08.2017', inFromId:= 8447, inToId:=8445 , inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ колбасный   + Склад МИНУСОВКА
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate:= TRUE, inStartDate:= '01.09.2017', inEndDate:= '30.09.2017', inFromId:= 981821, inToId:=951601 , inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ шприц. мясо   + ЦЕХ упаковки мясо
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate:= TRUE, inStartDate:= '01.07.2022', inEndDate:= '05.07.2022', inFromId:= 8020711, inToId:=8020714 , inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ шприц. мясо   + ЦЕХ упаковки мясо

