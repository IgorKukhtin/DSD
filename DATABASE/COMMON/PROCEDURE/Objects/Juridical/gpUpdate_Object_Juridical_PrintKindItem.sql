-- Function: gpUpdate_Object_Juridical_PrintKindItem()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_PrintKindItem (Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_PrintKindItem (Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_PrintKindItem(
    INOUT ioId                  Integer   ,  -- ключ объекта <> 
    INOUT ioisMovement          boolean   , 
    INOUT ioisAccount           boolean   ,
    INOUT ioisTransport         boolean   , 
    INOUT ioisQuality           boolean   , 
    INOUT ioisPack              boolean   , 
    INOUT ioisSpec              boolean   , 
    INOUT ioisTax               boolean   ,
    INOUT ioCountMovement       TFloat    , 
    INOUT ioCountAccount        TFloat    ,
    INOUT ioCountTransport      TFloat    , 
    INOUT ioCountQuality        TFloat    , 
    INOUT ioCountPack           TFloat    , 
    INOUT ioCountSpec           TFloat    , 
    INOUT ioCountTax            TFloat    ,
    IN inSession                TVarChar     -- сессия пользователя
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRetailId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_PrintKindItem());


   vbRetailId := (SELECT OL_Juridical_Retail.ChildObjectId 
              FROM ObjectLink AS OL_Juridical_Retail 
              WHERE OL_Juridical_Retail.ObjectId = ioId 
                AND OL_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail());

   IF  COALESCE (vbRetailId, 0) <> 0
   THEN
       RAISE EXCEPTION 'Ошибка. У юр.лица установлена сеть. Данные вводятся в справочнике <Торговая сеть (Элементы печати)>';
   END IF; 

    -- сохранили <Объект>
   ioId := lpInsertUpdate_Object_Juridical_PrintKindItem (ioId	         := ioId
                                                     , inisMovement      := ioisMovement
                                                     , inisAccount       := ioisAccount
                                                     , inisTransport     := ioisTransport
                                                     , inisQuality       := ioisQuality
                                                     , inisPack          := ioisPack
                                                     , inisSpec          := ioisSpec
                                                     , inisTax           := ioisTax
                                                     , inCountMovement   := ioCountMovement
                                                     , inCountAccount    := ioCountAccount
                                                     , inCountTransport  := ioCountTransport
                                                     , inCountQuality    := ioCountQuality
                                                     , inCountPack       := ioCountPack
                                                     , inCountSpec       := ioCountSpec
                                                     , inCountTax        := ioCountTax
                                                     , inUserId          := vbUserId
                                                      );

     -- возвращаем параметры
     SELECT tmp.isMovement, tmp.isAccount, tmp.isTransport
          , tmp.isQuality, tmp.isPack, tmp.isSpec, tmp.isTax
          , tmp.CountMovement, tmp.CountAccount, tmp.CountTransport
          , tmp.CountQuality, tmp.CountPack, tmp.CountSpec, tmp.CountTax
    INTO ioisMovement, ioisAccount, ioisTransport, ioisQuality, ioisPack, ioisSpec, ioisTax
       , ioCountMovement,ioCountAccount, ioCountTransport, ioCountQuality, ioCountPack, ioCountSpec, ioCountTax 
    FROM ObjectLink
       INNER JOIN lpSelect_Object_PrintKindItem() AS tmp ON tmp.Id = ObjectLink.ChildObjectId
    WHERE ObjectLink.DescId = zc_ObjectLink_Juridical_PrintKindItem()
    and ObjectLink.ObjectId = ioId;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.01.16
 21.05.15         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Retail_PrintKindItem(ioId:=null, inCode:=null, inName:='Торговая сеть 1', inSession:='2')