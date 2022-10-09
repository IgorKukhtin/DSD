-- Function: gpUpdate_Object_Partner_Params()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Params (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Params (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Params (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Params (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Params(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inRouteId             Integer   ,    -- 
    IN inRouteId_30201       Integer   ,    -- 
    IN inRouteSortingId      Integer   ,    -- 
    IN inMemberId            Integer   ,    -- 
    IN inPersonalId          Integer   ,    -- Сотрудник (супервайзер)
    IN inPersonalTradeId     Integer   ,    -- Сотрудник (торговый)
    IN inPersonalMerchId     Integer   ,    -- Сотрудник (мерчандайзер)
    IN inUnitId              Integer   ,    --            
    IN inBasisCode           Integer   ,    -- код Алан
    IN inPrepareDayCount     TFloat    ,    -- 
    IN inDocumentDayCount    TFloat    ,    -- 
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbRouteId Integer;
   DECLARE vbRouteId_30201 Integer;
   DECLARE vbRouteSortingId Integer;
   DECLARE vbMemberId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbPersonalTradeId Integer;
   DECLARE vbPersonalMerchId Integer;
   DECLARE vbUnitId Integer;  
   DECLARE vbPrepareDayCount TFloat;
   DECLARE vbDocumentDayCount TFloat;
   DECLARE vbBasisCode Integer;
BEGIN

   --разные права
   vbRouteId         := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_Route()) ::Integer;
   vbRouteId_30201   := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_Route30201()) ::Integer;
   vbRouteSortingId  := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_RouteSorting()) ::Integer;
   vbMemberId        := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_MemberTake()) ::Integer;
   vbPersonalId      := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_Personal()) ::Integer;
   vbPersonalTradeId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_PersonalTrade()) ::Integer;
   vbPersonalMerchId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_PersonalMerch()) ::Integer;
   vbUnitId          := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_Unit()) ::Integer; 
   vbPrepareDayCount := (SELECT ObjectFloat.ValueData    FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()) ::TFloat;
   vbDocumentDayCount:= (SELECT ObjectFloat.ValueData    FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()) ::TFloat;
   --
   vbBasisCode       := (SELECT ObjectFloat.ValueData    FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_ObjectCode_Basis()) ::Integer;

   IF COALESCE (vbRouteId,0) <> COALESCE (inRouteId,0)
   OR COALESCE (vbRouteId_30201,0) <> COALESCE (inRouteId_30201,0)
   OR COALESCE (vbRouteSortingId,0) <> COALESCE (inRouteSortingId,0)
   OR COALESCE (vbMemberId,0) <> COALESCE (inMemberId,0)
   OR COALESCE (vbPersonalId,0) <> COALESCE (inPersonalId,0)
   OR COALESCE (vbPersonalTradeId,0) <> COALESCE (inPersonalTradeId,0)
   OR COALESCE (vbPersonalMerchId,0) <> COALESCE (inPersonalMerchId,0)
   OR COALESCE (vbPrepareDayCount,0) <> COALESCE (inPrepareDayCount,0)
   OR COALESCE (vbDocumentDayCount,0)<> COALESCE (inDocumentDayCount,0)
   OR COALESCE (vbUnitId,0)          <> COALESCE (inUnitId,0)
   THEN
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_Params());


   -- временно захардкодил
   IF vbUserId = 715123 -- Осадчий Ю.В.
   THEN
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), ioId, inRouteId);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
   ELSE


   -- сохранили связь с <Сотрудник (супервайзер)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), ioId, inPersonalId);
   -- сохранили связь с <Сотрудник (торговый)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), ioId, inPersonalTradeId);
   -- сохранили связь с <Сотрудник (мерчандайзер)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalMerch(), ioId, inPersonalMerchId);


   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Unit(), ioId, inUnitId);


   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (106597 )) -- Торговый отдел
   THEN
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), ioId, inRouteId);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route30201(), ioId, inRouteId_30201);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTake(), ioId, inMemberId);

        -- сохранили свойство <За сколько дней принимается заказ>
        PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_PrepareDayCount(), ioId, inPrepareDayCount);
        -- сохранили свойство <Через сколько дней оформляется документально>
        PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_DocumentDayCount(), ioId, inDocumentDayCount);

   END IF;
   END IF; 
   END IF;
   
      --
   IF vbBasisCode <> inBasisCode
   THEN
        -- проверка прав пользователя на вызов процедуры
        vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectCode_Basis());
   
        -- сохранили свойство
        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ObjectCode_Basis(), ioId, inBasisCode);   
   END IF;



   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.06.17         * add inPersonalMerchId
 26.06.15                                        * add inRouteId_30201
 22.06.15                                        * all
 16.03.15                                        * all
 27.10.14                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_Params()
