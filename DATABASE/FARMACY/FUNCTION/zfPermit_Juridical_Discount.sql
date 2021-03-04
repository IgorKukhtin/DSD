-- Function: zfGet_Unit_Retail

DROP FUNCTION IF EXISTS zfGetCode_Juridical_Discount (Integer);

CREATE OR REPLACE FUNCTION zfPermit_Juridical_Discount (IN inDiscountExternal Integer , IN inJuridicalID Integer)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode Integer;
   DECLARE vbCodeProgram Integer;
BEGIN

  vbCode := COALESCE ((SELECT Object.ObjectCode FROM Object WHERE Object.ID = inDiscountExternal), 0);

  IF vbCode in (1) -- ЗАРАДИ ЖИТТЯ
                   -- Пфайзер "Заради життя онко-группа"
  THEN

     IF inJuridicalID in (59610, 59611, 59612)
     THEN
        RETURN inJuridicalID;
     END IF;
  ELSEIF vbCode in (2) -- Abbott card
  THEN

     vbCodeProgram := COALESCE((SELECT ObjectFloat_CodeRazom.ValueData
                                FROM ObjectFloat AS ObjectFloat_CodeRazom
                                WHERE ObjectFloat_CodeRazom.ObjectId = inJuridicalID
                                  AND ObjectFloat_CodeRazom.DescId = zc_ObjectFloat_Juridical_CodeRazom()), 0);
     IF vbCodeProgram in (1, 15, 14)
     THEN
        RETURN vbCodeProgram;
     END IF;
  ELSEIF vbCode in (3, 5, 6, 7, 8, 9, 11, 12, 13) -- Medicard
  THEN

     vbCodeProgram := COALESCE((SELECT ObjectFloat_CodeMedicard.ValueData
                                FROM ObjectFloat AS ObjectFloat_CodeMedicard
                                WHERE ObjectFloat_CodeMedicard.ObjectId = inJuridicalID
                                  AND ObjectFloat_CodeMedicard.DescId = zc_ObjectFloat_Juridical_CodeMedicard()), 0);

     IF vbCode = 3 AND vbCodeProgram in (1, 2, 3)      -- Medicard "Ценность для здоровья"
     THEN
        RETURN vbCodeProgram;
     ELSEIF vbCode = 5 AND vbCodeProgram in (1, 2, 3)  -- Медикард «Свобода руху з Мови Хелс»
     THEN
        RETURN vbCodeProgram;
     ELSEIF vbCode = 6 AND vbCodeProgram in (1)        -- Медикард+Фармак «Ваш зiр»
     THEN
        RETURN vbCodeProgram;
     ELSEIF vbCode = 7 AND vbCodeProgram in (1, 2)     -- Медикард+Артериум «Ключ до життя»
     THEN
        RETURN vbCodeProgram;
     ELSEIF vbCode = 8 AND vbCodeProgram in (1, 2)     -- Медикард+Артериум «Ключ до вiдновлення»
     THEN
        RETURN vbCodeProgram;
     ELSEIF vbCode = 9 AND vbCodeProgram in (1, 2, 3)  -- Медикард+Астра Зенека «Терапия плюс»
     THEN
        RETURN vbCodeProgram;
     ELSEIF vbCode = 11 AND vbCodeProgram in (1, 2, 3) -- Медикард + Адамед «Я бачу»
     THEN
        RETURN vbCodeProgram;
     ELSEIF vbCode = 12 AND vbCodeProgram in (1)       -- Медикард+ Эвер Нейро Фарма «На крок ближче до життя»
     THEN
        RETURN vbCodeProgram;
     ELSEIF vbCode = 13 AND vbCodeProgram in (1)       -- Медикард +Геолик Фарм «Захисти своє майбутнє»
     THEN
        RETURN vbCodeProgram;
     END IF;
  ELSEIF vbCode in (4, 10) -- Здоровье от Байер
                           -- Женское здоровье
  THEN
     RETURN inJuridicalID;
  ELSEIF vbCode in (15) -- Оранж Кард
  THEN

     vbCodeProgram := COALESCE((SELECT ObjectFloat_CodeOrangeCard.ValueData
                                FROM ObjectFloat AS ObjectFloat_CodeOrangeCard
                                WHERE ObjectFloat_CodeOrangeCard.ObjectId = inJuridicalID
                                  AND ObjectFloat_CodeOrangeCard.DescId = zc_ObjectFloat_Juridical_CodeOrangeCard()), 0);
     RETURN vbCodeProgram;
  ELSEIF vbCode in (16) -- Ксантис Забота
  THEN

     IF inJuridicalID in (59611)
     THEN
        RETURN inJuridicalID;
     END IF;
  END IF;

  RETURN 0;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfPermit_Juridical_Discount (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.03.21                                                       *
*/
/*
SELECT Object.*, ObjectFloat_CodeRazom.ValueData

FROM ObjectFloat AS ObjectFloat_CodeRazom
     inner join Object ON Object.ID = ObjectFloat_CodeRazom.objectid
WHERE ObjectFloat_CodeRazom.DescId = zc_ObjectFloat_Juridical_CodeOrangeCard()
  AND ObjectFloat_CodeRazom.ValueData <> 0
*/
-- тест
--

SELECT zfPermit_Juridical_Discount (inDiscountExternal := 4521216   , inJuridicalID := 59610);