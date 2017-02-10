-- Function: gpUpdate_Object_Partner_Order()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_GLN (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_GLN(
 INOUT ioId                  Integer  ,    -- ключ объекта <Контрагент> 
    IN inGLNCode             TVarChar ,    -- Код GLN
    IN inGLNCodeJuridical    TVarChar ,    -- Код GLN - Покупатель
    IN inGLNCodeRetail       TVarChar ,    -- Код GLN - Получатель
    IN inGLNCodeCorporate    TVarChar ,    -- Код GLN - Поставщик
   OUT outGLNCodeJuridical   TVarChar ,    -- Код GLN - Покупатель
   OUT outGLNCodeRetail      TVarChar ,    -- Код GLN - Получатель
   OUT outGLNCodeCorporate   TVarChar ,    -- Код GLN - Поставщик
    IN inSession             TVarChar      -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGLNCodeCorporate TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_GLN());

   -- определяется 
   vbGLNCodeCorporate:= (SELECT ValueData FROM ObjectString WHERE ObjectId = zc_Juridical_Basis() AND DescId = zc_ObjectString_Juridical_GLNCode());


   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCode(), ioId, inGLNCode);

   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeJuridical(), ioId, inGLNCodeJuridical);
   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeRetail(), ioId, inGLNCodeRetail);   
   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeCorporate(), ioId, inGLNCodeCorporate);   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


    -- 
    SELECT zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_GLNCode.ValueData
                                  , inGLNCodeJuridical_partner := ObjectString_GLNCodeJuridical.ValueData
                                  , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                   ) AS GLNCodeJuridical

         , zfCalc_GLNCodeRetail (inGLNCode               := ObjectString_GLNCode.ValueData
                               , inGLNCodeRetail_partner := ObjectString_GLNCodeRetail.ValueData
                               , inGLNCodeRetail         := ObjectString_Retail_GLNCode.ValueData
                               , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode.ValueData
                                ) AS GLNCodeRetail

         , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_GLNCode.ValueData
                                  , inGLNCodeCorporate_partner := ObjectString_GLNCodeCorporate.ValueData
                                  , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                  , inGLNCodeCorporate_main    := vbGLNCodeCorporate
                                   ) AS GLNCodeCorporate

           INTO outGLNCodeJuridical, outGLNCodeRetail, outGLNCodeCorporate

     FROM Object AS Object_Partner
         LEFT JOIN ObjectString AS ObjectString_GLNCode 
                                ON ObjectString_GLNCode.ObjectId = Object_Partner.Id 
                               AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()

         LEFT JOIN ObjectString AS ObjectString_GLNCodeJuridical
                                ON ObjectString_GLNCodeJuridical.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
         LEFT JOIN ObjectString AS ObjectString_GLNCodeRetail
                                ON ObjectString_GLNCodeRetail.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeRetail.DescId = zc_ObjectString_Partner_GLNCodeRetail()
         LEFT JOIN ObjectString AS ObjectString_GLNCodeCorporate
                                ON ObjectString_GLNCodeCorporate.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()                                                                  

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                ON ObjectString_Juridical_GLNCode.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                               AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
         LEFT JOIN ObjectString AS ObjectString_Retail_GLNCode
                                ON ObjectString_Retail_GLNCode.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                               AND ObjectString_Retail_GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
         LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                               AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

    WHERE Object_Partner.Id = ioId
   ;

   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.03.15         *

*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_GLN()
