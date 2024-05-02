-- Function: zfCalc_Text_parse

DROP FUNCTION IF EXISTS zfCalc_Text_parse (Text);
DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Text);
DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Text, Boolean);
DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Text, Boolean, Boolean);
DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Integer, Text, Boolean, Boolean);
DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Integer, Integer, Text, Boolean, Boolean);
-- DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Integer, Integer, Integer, Text, Boolean, Boolean);
-- DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Integer, Integer, Integer, Text, Boolean, Boolean, Boolean);
DROP FUNCTION IF EXISTS zfCalc_Text_parse (Integer, Integer, Integer, Integer, Text, Boolean, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION zfCalc_Text_parse(
    IN inStickerFileId Integer,
    IN inTradeMarkId   Integer,
    IN inAddLeft       Integer, -- Сколько пробелов добавим слева, т.е. это когда слева - Фирменный знак
    IN inAddLine       Integer, -- Был Ли перевод в несколько строк для Level1 или Level2, тогда по следующим строкам НУЖЕН сдвиг
    IN inValue         Text,
    IN inIsLength      Boolean,
    IN inIsLimit       Boolean, -- т.к. Раньше УМОВИ ... были в 8-ой строке, НУЖЕН был сдвиг вниз, т.е. в Info добавлялись пустые строки
    IN inIs70_70       Boolean,  -- 
    IN inUserId        Integer
)
RETURNS Text
AS
$BODY$
   DECLARE vbResult Text;
   DECLARE vbIndex  Integer;
   DECLARE vbLine   Integer;
   DECLARE vbLen    Integer;
   DECLARE vbI      Integer;
   DECLARE vbI_save Integer;

   DECLARE vbLen1  Integer;
   DECLARE vbLen2  Integer;
   DECLARE vbLen3  Integer;
   DECLARE vbLen4  Integer;
   DECLARE vbLen5  Integer;
   DECLARE vbLen6  Integer;
   DECLARE vbLen7  Integer;
   DECLARE vbLen8  Integer;
   DECLARE vbLen9  Integer;
   DECLARE vbLen10 Integer;
   DECLARE vbLen11 Integer;
   DECLARE vbLen12 Integer;
   DECLARE vbLen13 Integer;
   DECLARE vbLen14 Integer;
   DECLARE vbLen15 Integer;
   DECLARE vbTmp   Integer;
   
BEGIN

       SELECT CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width1_70_70.ValueData > 0 THEN ObjectFloat_Width1_70_70.ValueData   :: Integer
                   WHEN ObjectFloat_Width1.ValueData > 0  THEN ObjectFloat_Width1.ValueData  :: Integer                       
                   ELSE 1000                                                                                                  
              END AS Width1                                                                                                   
                                                                                                                              
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width2_70_70.ValueData > 0 THEN ObjectFloat_Width2_70_70.ValueData   :: Integer
                   WHEN ObjectFloat_Width2.ValueData > 0  THEN ObjectFloat_Width2.ValueData  :: Integer                       
                   ELSE 1000                                                                                                  
              END AS Width2                                                                                                   
                                                                                                                              
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width3_70_70.ValueData > 0 THEN ObjectFloat_Width3_70_70.ValueData   :: Integer
                   WHEN ObjectFloat_Width3.ValueData > 0  THEN ObjectFloat_Width3.ValueData  :: Integer                       
                   ELSE 1000                                                                                                  
              END AS Width3                                                                                                   
                                                                                                                              
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width4_70_70.ValueData > 0 THEN ObjectFloat_Width4_70_70.ValueData   :: Integer
                   WHEN ObjectFloat_Width4.ValueData > 0  THEN ObjectFloat_Width4.ValueData  :: Integer                       
                   ELSE 1000                                                                                                  
              END AS Width4                                                                                                   
                                                                                                                              
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width5_70_70.ValueData > 0 THEN ObjectFloat_Width5_70_70.ValueData   :: Integer
                   WHEN ObjectFloat_Width5.ValueData > 0  THEN ObjectFloat_Width5.ValueData  :: Integer                       
                   ELSE 1000                                                                                                  
              END AS Width5                                                                                                   
                                                                                                                              
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width6_70_70.ValueData > 0 THEN ObjectFloat_Width6_70_70.ValueData   :: Integer
                   WHEN ObjectFloat_Width6.ValueData > 0  THEN ObjectFloat_Width6.ValueData  :: Integer                       
                   ELSE 1000                                                                                                  
              END AS Width6                                                                                                   
                                                                                                                              
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width7_70_70.ValueData > 0 THEN ObjectFloat_Width7_70_70.ValueData   :: Integer
                   WHEN ObjectFloat_Width7.ValueData > 0  THEN ObjectFloat_Width7.ValueData  :: Integer                       
                   ELSE 50
              END AS Width7                                                                                                   
                                                                                                                              
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width8_70_70.ValueData > 0 THEN ObjectFloat_Width8_70_70.ValueData   :: Integer
                   WHEN ObjectFloat_Width8.ValueData > 0  THEN ObjectFloat_Width8.ValueData  :: Integer                       
                   ELSE 50
              END AS Width8                                                                                                   
                                                                                                                              
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width9_70_70.ValueData > 0 THEN ObjectFloat_Width9_70_70.ValueData   :: Integer
                   WHEN ObjectFloat_Width9.ValueData > 0  THEN ObjectFloat_Width9.ValueData  :: Integer 
                   ELSE 50
              END AS Width9

              -- 10
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width10_70_70.ValueData > 0 THEN ObjectFloat_Width10_70_70.ValueData :: Integer
                   WHEN ObjectFloat_Width10.ValueData > 0 THEN ObjectFloat_Width10.ValueData :: Integer - 1 
                   ELSE 30
              END AS Width10
              -- 11
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width10_70_70.ValueData > 0 THEN ObjectFloat_Width10_70_70.ValueData :: Integer
                   WHEN ObjectFloat_Width10.ValueData > 0 THEN ObjectFloat_Width10.ValueData :: Integer - 1 
                   ELSE 50
              END AS Width11
              -- 12
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width10_70_70.ValueData > 0 THEN ObjectFloat_Width10_70_70.ValueData :: Integer
                   WHEN ObjectFloat_Width10.ValueData > 0 THEN ObjectFloat_Width10.ValueData :: Integer - 1 
                   ELSE 50
              END AS Width12

              -- 13
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width10_70_70.ValueData > 0 THEN ObjectFloat_Width10_70_70.ValueData  :: Integer
                   WHEN ObjectFloat_Width10.ValueData > 0 THEN ObjectFloat_Width10.ValueData :: Integer - 1 
                   ELSE 50
              END AS Width13
              -- 14
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width10_70_70.ValueData > 0 THEN ObjectFloat_Width10_70_70.ValueData  :: Integer
                   WHEN ObjectFloat_Width10.ValueData > 0 THEN ObjectFloat_Width10.ValueData :: Integer - 1 
                   ELSE 50
              END AS Width14
              -- 15
            , CASE WHEN inIs70_70 = TRUE AND ObjectFloat_Width10_70_70.ValueData > 0 THEN ObjectFloat_Width10_70_70.ValueData  :: Integer
                   WHEN ObjectFloat_Width10.ValueData > 0 THEN ObjectFloat_Width10.ValueData :: Integer - 1 
                   ELSE 50
              END AS Width15


              INTO vbLen1
                 , vbLen2
                 , vbLen3
                 , vbLen4
                 , vbLen5
                 , vbLen6
                 , vbLen7
                 , vbLen8
                 , vbLen9
                 , vbLen10

                 , vbLen11
                 , vbLen12

                 , vbLen13
                 , vbLen14
                 , vbLen15

       FROM Object AS Object_StickerFile
            LEFT JOIN ObjectFloat AS ObjectFloat_Width1
                                  ON ObjectFloat_Width1.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width1.DescId   = zc_ObjectFloat_StickerFile_Width1()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width1_70_70
                                  ON ObjectFloat_Width1_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width1_70_70.DescId   = zc_ObjectFloat_StickerFile_Width1_70_70()
                                 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width2
                                  ON ObjectFloat_Width2.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width2.DescId   = zc_ObjectFloat_StickerFile_Width2()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width2_70_70
                                  ON ObjectFloat_Width2_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width2_70_70.DescId   = zc_ObjectFloat_StickerFile_Width2_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width3
                                  ON ObjectFloat_Width3.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width3.DescId   = zc_ObjectFloat_StickerFile_Width3()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width3_70_70
                                  ON ObjectFloat_Width3_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width3_70_70.DescId   = zc_ObjectFloat_StickerFile_Width3_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width4
                                  ON ObjectFloat_Width4.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width4.DescId   = zc_ObjectFloat_StickerFile_Width4()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width4_70_70
                                  ON ObjectFloat_Width4_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width4_70_70.DescId   = zc_ObjectFloat_StickerFile_Width4_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width5
                                  ON ObjectFloat_Width5.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width5.DescId   = zc_ObjectFloat_StickerFile_Width5()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width5_70_70
                                  ON ObjectFloat_Width5_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width5_70_70.DescId   = zc_ObjectFloat_StickerFile_Width5_70_70()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width6
                                  ON ObjectFloat_Width6.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width6.DescId   = zc_ObjectFloat_StickerFile_Width6()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width6_70_70
                                  ON ObjectFloat_Width6_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width6_70_70.DescId   = zc_ObjectFloat_StickerFile_Width6_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width7
                                  ON ObjectFloat_Width7.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width7.DescId   = zc_ObjectFloat_StickerFile_Width7()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width7_70_70
                                  ON ObjectFloat_Width7_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width7_70_70.DescId   = zc_ObjectFloat_StickerFile_Width7_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width8
                                  ON ObjectFloat_Width8.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width8.DescId   = zc_ObjectFloat_StickerFile_Width8()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width8_70_70
                                  ON ObjectFloat_Width8_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width8_70_70.DescId   = zc_ObjectFloat_StickerFile_Width8_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width9
                                  ON ObjectFloat_Width9.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width9.DescId   = zc_ObjectFloat_StickerFile_Width9()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width9_70_70
                                  ON ObjectFloat_Width9_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width9_70_70.DescId   = zc_ObjectFloat_StickerFile_Width9_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width10
                                  ON ObjectFloat_Width10.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width10.DescId   = zc_ObjectFloat_StickerFile_Width10() 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width10_70_70
                                  ON ObjectFloat_Width10_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width10_70_70.DescId   = zc_ObjectFloat_StickerFile_Width10_70_70() 

       WHERE Object_StickerFile.Id     = inStickerFileId
         AND Object_StickerFile.DescId = zc_Object_StickerFile()
        ;


    -- RAISE EXCEPTION '<%>', inTradeMarkId;

    IF COALESCE (vbLen1, 1000) = 1000 AND inTradeMarkId = 293382 -- select * from object where Id = 293382
    THEN
         -- тм СПЕЦ ЦЕХ
         vbLen1  := 40;
         vbLen2  := 45;
         vbLen3  := 45;
         vbLen4  := 48;
         vbLen5  := 48;
         vbLen6  := 1000;
         vbLen7  := 1000;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    ELSEIF COALESCE (vbLen1, 1000) = 1000 AND inTradeMarkId = 293383 -- select * from object where Id = 293383
    THEN
         -- тм ВАРТО (Варус)
         vbLen1  := 40;
         vbLen2  := 50;
         vbLen3  := 50;
         vbLen4  := 57;
         vbLen5  := 62;
         vbLen6  := 1000;
         vbLen7  := 1000;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    ELSEIF COALESCE (vbLen1, 1000) = 1000 AND inTradeMarkId = 293384 -- select * from object where Id = 293384
    THEN
         -- тм НАШИ КОВБАСИ
         vbLen1  := 40;
         vbLen2  := 47;
         vbLen3  := 47;
         vbLen4  := 47;
         vbLen5  := 50;
         vbLen6  := 50;
         vbLen7  := 55;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    ELSEIF COALESCE (vbLen1, 1000) = 1000 AND inTradeMarkId = 340617 -- select * from object where Id = 340617
    THEN
         -- тм Повна Чаша (Фоззи)
         vbLen1  := 50;
         vbLen2  := 50;
         vbLen3  := 50;
         vbLen4  := 50;
         vbLen5  := 50;
         vbLen6  := 1000;
         vbLen7  := 1000;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    ELSEIF COALESCE (vbLen1, 1000) = 1000 AND inTradeMarkId = 340618 -- select * from object where Id = 340617
    THEN
         -- тм Премія (Фоззи)
         vbLen1  := 35;
         vbLen2  := 35;
         vbLen3  := 35;
         vbLen4  := 35;
         vbLen5  := 35;
         vbLen6  := 1000;
         vbLen7  := 1000;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    ELSEIF COALESCE (vbLen1, 1000) = 1000 AND inTradeMarkId = 342992 -- select * from object where Id = 342992
    THEN
         -- тм Ашан
         vbLen1  := 40;
         vbLen2  := 1000;
         vbLen3  := 1000;
         vbLen4  := 1000;
         vbLen5  := 1000;
         vbLen6  := 1000;
         vbLen7  := 1000;
         vbLen8  := 1000;
         vbLen9  := 1000;
         vbLen10 := 1000;

    ELSEIF COALESCE (vbLen1, 1000) = 1000
    THEN
         -- тм АЛАН
         vbLen1  := 40;
         vbLen2  := 48;
         vbLen3  := 43;
         vbLen4  := 43;
         vbLen5  := 47;
         vbLen6  := 47;
         vbLen7  := 47;
         vbLen8  := 50;
         vbLen9  := 1000;
         vbLen10 := 1000;

    END IF;


    vbIndex:= 0;
    vbLine:= 1;
    vbResult:= '';

    -- старт
    WHILE vbIndex < LENGTH (inValue) -- OR (vbLine <= 8 AND inTradeMarkId = 293385 AND inIsLimit = TRUE) -- тм АЛАН -- select * from object where Id = 293385
                                     -- OR (vbLine <= 7 AND inTradeMarkId = 293385) -- тм АЛАН -- select * from object where Id = 293385
    LOOP
       --
       vbLen:= CASE vbLine + inAddLine
                    WHEN 1  THEN vbLen1
                    WHEN 2  THEN vbLen2
                    WHEN 3  THEN vbLen3
                    WHEN 4  THEN vbLen4
                    WHEN 5  THEN vbLen5
                    WHEN 6  THEN vbLen6
                    WHEN 7  THEN vbLen7
                    WHEN 8  THEN vbLen8
                    WHEN 9  THEN vbLen9
                    WHEN 10 THEN vbLen10
                    WHEN 11 THEN vbLen11
                    WHEN 12 THEN vbLen12
                    WHEN 13 THEN vbLen13
                    WHEN 14 THEN vbLen14
                    WHEN 15 THEN vbLen15
                    --
                    WHEN 16 THEN vbLen15
                    WHEN 17 THEN vbLen15
                    WHEN 18 THEN vbLen15
                    WHEN 19 THEN vbLen15
                    WHEN 20 THEN vbLen15
                            ELSE 45
               END;
               
       vbTmp:= vbLen;

       /*IF SUBSTRING (inValue FROM vbIndex + vbLen - 1 FOR 1) = ' '
       THEN vbLen:= vbLen + 1;
       ELSEIF SUBSTRING (inValue FROM vbIndex + vbLen + 2 FOR 1) = ' '
       THEN vbLen:= vbLen - 1;
       END IF;*/


       vbI:= 1;
       vbI_save:= vbLen;
       

       WHILE vbI <= vbLen AND SUBSTRING (inValue FROM vbIndex + vbI + 1 FOR 1) NOT IN ('~')
       LOOP

           IF SUBSTRING (inValue FROM vbIndex + 1 + vbI FOR 3) IN ('<b>') AND inUserId = 5 AND 1=0
           THEN vbI_save:= vbI + 3;
           ELSEIF SUBSTRING (inValue FROM vbIndex + 1 + vbI FOR 4) IN ('</b>') AND inUserId = 5 AND 1=0
           THEN vbI_save:= vbI + 4;
           ELSEIF SUBSTRING (inValue FROM vbIndex + 1 + vbI FOR 1) IN (' ', '.', ',', '-', '/', ':') -- , '(', ')'
           THEN vbI_save:= vbI + 1;
           END IF;

           vbI:= vbI + 1;

       END LOOP;

       IF vbIndex + vbI < LENGTH (inValue)
       THEN vbLen:= vbI_save;
       END IF;

       vbResult:= vbResult
               || CASE WHEN vbLine = 1 THEN '' ELSE CHR (13) END
               || CASE WHEN vbLen < 1000 THEN REPEAT (' ', inAddLeft) ELSE '' END
               || TRIM (SUBSTRING (inValue FROM vbIndex + 1 FOR vbLen))
               --|| CASE WHEN inUserId = 5 THEN '*' || vbLen :: TVarChar ELSE '' END
               || CASE WHEN inIsLength = TRUE THEN ' ' || LENGTH ( TRIM (SUBSTRING (inValue FROM vbIndex + 1 FOR vbLen))) :: TVarChar || '-' || (vbLine + inAddLine) :: TVarChar ELSE '' END
               -- || CASE WHEN inIsLength = TRUE THEN '*' || (vbIndex + vbLen) :: TVarChar || '*' || LENGTH (inValue) :: TVarChar ELSE '' END
               
                 ;

IF inUserId = 5 and vbLine = 3 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.<%>', 
                 CASE WHEN vbLine = 1 THEN '' ELSE CHR (13) END
               || CASE WHEN vbLen < 1000 THEN REPEAT (' ', inAddLeft) ELSE '' END
               || TRIM (SUBSTRING (inValue FROM vbIndex + 1 FOR vbLen))
|| ' * ' || vbLen :: TVarChar  || ' * ' || vbLen3 :: TVarChar  || ' * '
               || CASE WHEN inIsLength = TRUE THEN ' ' || LENGTH ( TRIM (SUBSTRING (inValue FROM vbIndex + 1 FOR vbLen))) :: TVarChar || '-' || (vbLine + inAddLine) :: TVarChar ELSE '' END
               ;
END IF;

       -- сдвинули на один
       IF SUBSTRING (inValue FROM vbIndex + vbLen + 2 FOR 1) IN ('~') THEN vbIndex:= vbIndex + 1; END IF;

       -- теперь следуюющий
       vbLine:= vbLine + 1;
       vbIndex:= vbIndex + vbLen;

    END LOOP;

    RETURN COALESCE (vbResult, '');

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.16                                        *
*/

-- тест
-- SELECT * FROM zfCalc_Text_parse (inStickerFileId:= 0, inTradeMarkId:= 1, inAddLeft:= 0, inAddLine:= 0, inValue:= 'asdsadasdasdasdasdasdasdasdasdasd', inIsLength:= TRUE, inIsLimit:= TRUE, inIs70_70:= TRUE, inUserId:= 5)
