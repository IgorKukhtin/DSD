-- Function: gpInsertUpdate_Object_Boat_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Boat_From_Excel (TDateTime , TDateTime, TDateTime, TVarChar, 
                                                               TVarChar  ,TVarChar  ,TVarChar  ,TVarChar  ,
                                                               TFloat ,TVarChar  ,TFloat   ,TVarChar  ,TVarChar  ,TVarChar  ,
                                                               TVarChar  ,TVarChar  ,TVarChar  ,TVarChar  , TVarChar  ,TVarChar  ,TVarChar  ,TVarChar  ,TVarChar  ,
                                                               TVarChar  ,TVarChar  ,TVarChar  ,TVarChar  ,TVarChar  ,TVarChar  ,TVarChar  ,
                                                               TVarChar  ,TVarChar  ,  TFloat    ,TVarChar  ,TVarChar  ,
                                                               TFloat    ,TVarChar  ,TVarChar  ,TFloat    ,TVarChar  , TVarChar  ,
                                                               TFloat    ,TVarChar  ,TVarChar  ,TFloat    ,TVarChar  ,TVarChar  ,
                                                               TFloat    ,TVarChar  ,TVarChar  ,TFloat    ,TVarChar  ,TVarChar  ,TFloat    ,
                                                               TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat
                                                               TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Boat_From_Excel(
    IN inDateStart           TDateTime  ,    -- Код ИНН
    IN inDateBegin           TDateTime  ,    -- № карточного счета ЗП ф1
    IN inDateSale            TDateTime  ,    -- № карточного счета IBAN ЗП ф1
    IN inArticle             TVarChar  ,    -- Название объекта <
    
    IN inBrand               TVarChar  ,
    IN inModel               TVarChar  ,
    IN inCIN                 TVarChar  ,
    IN inEngine              TVarChar  ,
    IN inPower               TFloat ,
    IN inEngineNum           TVarChar  ,
    IN inHours               TFloat   ,
    IN inHypalon1            TVarChar  ,
    IN inHypalon2            TVarChar  ,
    IN inHypalon3            TVarChar  ,
    IN inHypalon4            TVarChar  ,
    IN inHypalon5            TVarChar  ,
    IN inFiberglassHull      TVarChar  ,
    IN inFiberglassDeck      TVarChar  ,
    IN inFiberglassSteeringConsole    TVarChar  ,
    IN inUpholstery1         TVarChar  ,
    IN inUpholstery2         TVarChar  ,
    IN inUpholstery3         TVarChar  ,
    IN inUpholstery4         TVarChar  ,
    IN inStitchingcolor      TVarChar  ,
    IN inStitchingtype       TVarChar  ,
    IN inColor1              TVarChar  ,
    IN inColor2              TVarChar  ,
    IN inColor3              TVarChar  ,
    IN inColor4              TVarChar  ,
    IN inColor5              TVarChar  ,

    IN inOption1             TVarChar  ,
    IN inOptionPartnumber1   TVarChar  ,  
    IN inOptionPrice1        TFloat    ,
    IN inOption2             TVarChar  ,
    IN inOptionPartnumber2   TVarChar  ,
    IN inOptionPrice2        TFloat    ,
    IN inOption3             TVarChar  ,
    IN inOptionPartnumber3   TVarChar  ,
    IN inOptionPrice3        TFloat    ,
    IN inOption4             TVarChar  , 
    IN inOptionPartnumber4   TVarChar  ,
    IN inOptionPrice4        TFloat    ,
    IN inOption5             TVarChar  ,
    IN inOptionPartnumber5   TVarChar  ,
    IN inOptionPrice5        TFloat    ,
    IN inOption6             TVarChar  ,
    IN inOptionPartnumber6   TVarChar  ,
    IN inOptionPrice6        TFloat    ,
    IN inOption7             TVarChar  ,
    IN inOptionPartnumber7   TVarChar  ,
    IN inOptionPrice7        TFloat    ,
    IN inOption8             TVarChar  ,
    IN inOptionPartnumber8   TVarChar  ,
    IN inOptionPrice8        TFloat    ,

    IN inLength     TFloat,
    IN inBeam       TFloat,
    IN inHeight     TFloat,
    IN inWeight     TFloat,
    IN inFuel       TFloat,
    IN inSpeed      TFloat,
    IN inSeating    TFloat
    
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());


     --  RAISE EXCEPTION 'Ошибка. Код ИНН <%> не найден <%>.', TRIM (inINN), inName;

      -- сохранили протокол
      --PERFORM lpInsert_ObjectProtocol (vbMemberId, vbUserId);
   END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.10.20         *
*/


/*
select * from gpSelect_Object_ImportSettingsItems(inImportSettingsId := 1321 ,  inSession := '3');
select * from gpSelect_Object_ImportSettings( inSession := '3');

*/