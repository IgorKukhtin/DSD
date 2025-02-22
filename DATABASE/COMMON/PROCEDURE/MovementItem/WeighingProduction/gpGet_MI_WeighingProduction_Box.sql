-- Function: gpGet_MI_WeighingProduction_Box()

DROP FUNCTION IF EXISTS gpGet_MI_WeighingProduction_Box (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_WeighingProduction_Box(
    IN inId          Integer      , -- ключ строки
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , CountTare1 TFloat, CountTare2 TFloat, CountTare3 TFloat, CountTare4 TFloat, CountTare5 TFloat
             , CountTare6 TFloat, CountTare7 TFloat, CountTare8 TFloat, CountTare9 TFloat, CountTare10 TFloat
             , BoxWeight1 TFloat, BoxWeight2 TFloat, BoxWeight3 TFloat, BoxWeight4 TFloat, BoxWeight5 TFloat
             , BoxWeight6 TFloat, BoxWeight7 TFloat, BoxWeight8 TFloat, BoxWeight9 TFloat, BoxWeight10 TFloat
             , BoxWeight1_Tare TFloat, BoxWeight2_Tare TFloat, BoxWeight3_Tare TFloat, BoxWeight4_Tare TFloat, BoxWeight5_Tare TFloat
             , BoxWeight6_Tare TFloat, BoxWeight7_Tare TFloat, BoxWeight8_Tare TFloat, BoxWeight9_Tare TFloat, BoxWeight10_Tare TFloat
             , BoxWeightTotal TFloat
             , NettoWeight TFloat
             , RealWeight TFloat
             , BoxId_1 Integer, BoxId_2 Integer, BoxId_3 Integer, BoxId_4 Integer, BoxId_5 Integer
             , BoxId_6 Integer, BoxId_7 Integer, BoxId_8 Integer, BoxId_9 Integer, BoxId_10 Integer
             , BoxName_1 TVarChar, BoxName_2 TVarChar, BoxName_3 TVarChar, BoxName_4 TVarChar, BoxName_5 TVarChar
             , BoxName_6 TVarChar, BoxName_7 TVarChar, BoxName_8 TVarChar, BoxName_9 TVarChar, BoxName_10 TVarChar
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingProduction());

     -- inShowAll:= TRUE;
     IF COALESCE (inId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Строка не определена.';
     END IF;

     RETURN QUERY
     WITH
     tmpBox AS (SELECT MAX (tmp.BoxId_1) AS BoxId_1, MAX (tmp.BoxName_1) AS BoxName_1, MAX (tmp.BoxWeight1) AS BoxWeight1
                     , MAX (tmp.BoxId_2) AS BoxId_2, MAX (tmp.BoxName_2) AS BoxName_2, MAX (tmp.BoxWeight2) AS BoxWeight2
                     , MAX (tmp.BoxId_3) AS BoxId_3, MAX (tmp.BoxName_3) AS BoxName_3, MAX (tmp.BoxWeight3) AS BoxWeight3
                     , MAX (tmp.BoxId_4) AS BoxId_4, MAX (tmp.BoxName_4) AS BoxName_4, MAX (tmp.BoxWeight4) AS BoxWeight4
                     , MAX (tmp.BoxId_5) AS BoxId_5, MAX (tmp.BoxName_5) AS BoxName_5, MAX (tmp.BoxWeight5) AS BoxWeight5
                     , MAX (tmp.BoxId_6) AS BoxId_6, MAX (tmp.BoxName_6) AS BoxName_6, MAX (tmp.BoxWeight6) AS BoxWeight6
                     , MAX (tmp.BoxId_7) AS BoxId_7, MAX (tmp.BoxName_7) AS BoxName_7, MAX (tmp.BoxWeight7) AS BoxWeight7
                     , MAX (tmp.BoxId_8) AS BoxId_8, MAX (tmp.BoxName_8) AS BoxName_8, MAX (tmp.BoxWeight8) AS BoxWeight8
                     , MAX (tmp.BoxId_9) AS BoxId_9, MAX (tmp.BoxName_9) AS BoxName_9, MAX (tmp.BoxWeight9) AS BoxWeight9
                     , MAX (tmp.BoxId_10) AS BoxId_10, MAX (tmp.BoxName_10) AS BoxName_10, MAX (tmp.BoxWeight10) AS BoxWeight10
                FROM (
                      SELECT CASE WHEN spSelect.NPP = 1  THEN spSelect.Id ELSE 0 END    AS BoxId_1
                           , CASE WHEN spSelect.NPP = 1  THEN spSelect.Name ELSE '' END AS BoxName_1
                           , CASE WHEN spSelect.NPP = 2  THEN spSelect.Id ELSE 0 END    AS BoxId_2
                           , CASE WHEN spSelect.NPP = 2  THEN spSelect.Name ELSE '' END AS BoxName_2
                           , CASE WHEN spSelect.NPP = 3  THEN spSelect.Id ELSE 0 END    AS BoxId_3
                           , CASE WHEN spSelect.NPP = 3  THEN (spSelect.Name || CHR (13) || ' ('|| zfConvert_FloatToString (spSelect.BoxWeight) ||' кг.)') ELSE '' END AS BoxName_3
                           , CASE WHEN spSelect.NPP = 4  THEN spSelect.Id ELSE 0 END    AS BoxId_4
                           , CASE WHEN spSelect.NPP = 4  THEN (spSelect.Name || CHR (13) || ' ('|| zfConvert_FloatToString (spSelect.BoxWeight) ||' кг.)') ELSE '' END AS BoxName_4
                           , CASE WHEN spSelect.NPP = 5  THEN spSelect.Id ELSE 0 END    AS BoxId_5
                           , CASE WHEN spSelect.NPP = 5  THEN (spSelect.Name || CHR (13) || ' ('|| zfConvert_FloatToString (spSelect.BoxWeight) ||' кг.)') ELSE '' END AS BoxName_5
                           , CASE WHEN spSelect.NPP = 6  THEN spSelect.Id ELSE 0 END    AS BoxId_6
                           , CASE WHEN spSelect.NPP = 6  THEN (spSelect.Name || CHR (13) || ' ('|| zfConvert_FloatToString (spSelect.BoxWeight) ||' кг.)') ELSE '' END AS BoxName_6
                           , CASE WHEN spSelect.NPP = 7  THEN spSelect.Id ELSE 0 END    AS BoxId_7
                           , CASE WHEN spSelect.NPP = 7  THEN (spSelect.Name || CHR (13) || ' ('|| zfConvert_FloatToString (spSelect.BoxWeight) ||' кг.)') ELSE '' END AS BoxName_7
                           , CASE WHEN spSelect.NPP = 8  THEN spSelect.Id ELSE 0 END    AS BoxId_8
                           , CASE WHEN spSelect.NPP = 8  THEN (spSelect.Name || CHR (13) || ' ('|| zfConvert_FloatToString (spSelect.BoxWeight) ||' кг.)') ELSE '' END AS BoxName_8
                           , CASE WHEN spSelect.NPP = 9  THEN spSelect.Id ELSE 0 END    AS BoxId_9
                           , CASE WHEN spSelect.NPP = 9  THEN (spSelect.Name || CHR (13) || ' ('|| zfConvert_FloatToString (spSelect.BoxWeight) ||' кг.)') ELSE '' END AS BoxName_9
                           , CASE WHEN spSelect.NPP = 10 THEN spSelect.Id ELSE 0 END    AS BoxId_10
                           , CASE WHEN spSelect.NPP = 10 THEN (spSelect.Name || CHR (13) || ' ('|| zfConvert_FloatToString (spSelect.BoxWeight) ||' кг.)') ELSE '' END AS BoxName_10

                           , CASE WHEN spSelect.NPP = 1 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight1
                           , CASE WHEN spSelect.NPP = 2 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight2
                           , CASE WHEN spSelect.NPP = 3 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight3
                           , CASE WHEN spSelect.NPP = 4 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight4
                           , CASE WHEN spSelect.NPP = 5 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight5
                           , CASE WHEN spSelect.NPP = 6 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight6
                           , CASE WHEN spSelect.NPP = 7 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight7
                           , CASE WHEN spSelect.NPP = 8 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight8
                           , CASE WHEN spSelect.NPP = 9 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight9
                           , CASE WHEN spSelect.NPP = 10 THEN spSelect.BoxWeight ELSE 0 END   AS BoxWeight10

                      FROM gpSelect_Object_Box (inSession) AS spSelect
                      ) AS tmp
                )

    , tmpData AS (SELECT
             MovementItem.Id

           , CASE WHEN tmpBox.BoxId_1 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                  WHEN tmpBox.BoxId_1 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                  WHEN tmpBox.BoxId_1 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                  WHEN tmpBox.BoxId_1 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                  WHEN tmpBox.BoxId_1 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
             END   ::TFloat AS CountTare1
           , CASE WHEN tmpBox.BoxId_2 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                  WHEN tmpBox.BoxId_2 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                  WHEN tmpBox.BoxId_2 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                  WHEN tmpBox.BoxId_2 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                  WHEN tmpBox.BoxId_2 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
             END   ::TFloat AS CountTare2
           , CASE WHEN tmpBox.BoxId_3 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                  WHEN tmpBox.BoxId_3 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                  WHEN tmpBox.BoxId_3 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                  WHEN tmpBox.BoxId_3 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                  WHEN tmpBox.BoxId_3 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
             END   ::TFloat AS CountTare3
           , CASE WHEN tmpBox.BoxId_4 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                  WHEN tmpBox.BoxId_4 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                  WHEN tmpBox.BoxId_4 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                  WHEN tmpBox.BoxId_4 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                  WHEN tmpBox.BoxId_4 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
             END   ::TFloat AS CountTare4
           , CASE WHEN tmpBox.BoxId_5 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                  WHEN tmpBox.BoxId_5 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                  WHEN tmpBox.BoxId_5 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                  WHEN tmpBox.BoxId_5 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                  WHEN tmpBox.BoxId_5 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
             END   ::TFloat AS CountTare5
           , CASE WHEN tmpBox.BoxId_6 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                  WHEN tmpBox.BoxId_6 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                  WHEN tmpBox.BoxId_6 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                  WHEN tmpBox.BoxId_6 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                  WHEN tmpBox.BoxId_6 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
             END   ::TFloat AS CountTare6
           , CASE WHEN tmpBox.BoxId_7 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                  WHEN tmpBox.BoxId_7 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                  WHEN tmpBox.BoxId_7 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                  WHEN tmpBox.BoxId_7 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                  WHEN tmpBox.BoxId_7 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
             END   ::TFloat AS CountTare7
           , CASE WHEN tmpBox.BoxId_8 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                  WHEN tmpBox.BoxId_8 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                  WHEN tmpBox.BoxId_8 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                  WHEN tmpBox.BoxId_8 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                  WHEN tmpBox.BoxId_8 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
             END   ::TFloat AS CountTare8
           , CASE WHEN tmpBox.BoxId_9 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                  WHEN tmpBox.BoxId_9 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                  WHEN tmpBox.BoxId_9 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                  WHEN tmpBox.BoxId_9 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                  WHEN tmpBox.BoxId_9 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
             END   ::TFloat AS CountTare9
           , CASE WHEN tmpBox.BoxId_10 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                  WHEN tmpBox.BoxId_10 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                  WHEN tmpBox.BoxId_10 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                  WHEN tmpBox.BoxId_10 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                  WHEN tmpBox.BoxId_10 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
             END   ::TFloat AS CountTare10

           , tmpBox.BoxWeight1 ::TFloat, tmpBox.BoxWeight2 ::TFloat, tmpBox.BoxWeight3 ::TFloat, tmpBox.BoxWeight4 ::TFloat, tmpBox.BoxWeight5 ::TFloat
           , tmpBox.BoxWeight6 ::TFloat, tmpBox.BoxWeight7 ::TFloat, tmpBox.BoxWeight8 ::TFloat, tmpBox.BoxWeight9 ::TFloat, tmpBox.BoxWeight10 ::TFloat

           , MIFloat_RealWeight.ValueData ::TFloat AS RealWeight

           , tmpBox.BoxId_1, tmpBox.BoxId_2, tmpBox.BoxId_3, tmpBox.BoxId_4, tmpBox.BoxId_5
           , tmpBox.BoxId_6, tmpBox.BoxId_7, tmpBox.BoxId_8, tmpBox.BoxId_9, tmpBox.BoxId_10
           , tmpBox.BoxName_1 ::TVarChar, tmpBox.BoxName_2 ::TVarChar, tmpBox.BoxName_3 ::TVarChar, tmpBox.BoxName_4 ::TVarChar, tmpBox.BoxName_5 ::TVarChar
           , tmpBox.BoxName_6 ::TVarChar, tmpBox.BoxName_7 ::TVarChar, tmpBox.BoxName_8 ::TVarChar, tmpBox.BoxName_9 ::TVarChar, tmpBox.BoxName_10 ::TVarChar

       FROM MovementItem
           LEFT JOIN tmpBox ON 1=1

           LEFT JOIN MovementItemFloat AS MIFloat_CountTare1
                                       ON MIFloat_CountTare1.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare1.DescId = zc_MIFloat_CountTare1()
           LEFT JOIN MovementItemFloat AS MIFloat_CountTare2
                                       ON MIFloat_CountTare2.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare2.DescId = zc_MIFloat_CountTare2()
           LEFT JOIN MovementItemFloat AS MIFloat_CountTare3
                                       ON MIFloat_CountTare3.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare3.DescId = zc_MIFloat_CountTare3()
           LEFT JOIN MovementItemFloat AS MIFloat_CountTare4
                                       ON MIFloat_CountTare4.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare4.DescId = zc_MIFloat_CountTare4()
           LEFT JOIN MovementItemFloat AS MIFloat_CountTare5
                                       ON MIFloat_CountTare5.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountTare5.DescId = zc_MIFloat_CountTare5()

           LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                       ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                      AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

           LEFT JOIN MovementItemLinkObject AS MILinkObject_Box1
                                            ON MILinkObject_Box1.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Box1.DescId = zc_MILinkObject_Box1()
           LEFT JOIN Object AS Object_Box1 ON Object_Box1.Id = MILinkObject_Box1.ObjectId

           LEFT JOIN MovementItemLinkObject AS MILinkObject_Box2
                                            ON MILinkObject_Box2.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Box2.DescId = zc_MILinkObject_Box2()
           LEFT JOIN Object AS Object_Box2 ON Object_Box2.Id = MILinkObject_Box2.ObjectId

           LEFT JOIN MovementItemLinkObject AS MILinkObject_Box3
                                            ON MILinkObject_Box3.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Box3.DescId = zc_MILinkObject_Box3()
           LEFT JOIN Object AS Object_Box3 ON Object_Box3.Id = MILinkObject_Box3.ObjectId

           LEFT JOIN MovementItemLinkObject AS MILinkObject_Box4
                                            ON MILinkObject_Box4.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Box4.DescId = zc_MILinkObject_Box4()
           LEFT JOIN Object AS Object_Box4 ON Object_Box4.Id = MILinkObject_Box4.ObjectId

           LEFT JOIN MovementItemLinkObject AS MILinkObject_Box5
                                            ON MILinkObject_Box5.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Box5.DescId = zc_MILinkObject_Box5()
           LEFT JOIN Object AS Object_Box5 ON Object_Box5.Id = MILinkObject_Box5.ObjectId
       WHERE MovementItem.DescId = zc_MI_Master()
         AND MovementItem.Id = inId
         )
    --результат
    SELECT
             tmpBox.Id

           , tmpBox.CountTare1    ::TFloat
           , tmpBox.CountTare2    ::TFloat
           , tmpBox.CountTare3    ::TFloat
           , tmpBox.CountTare4    ::TFloat
           , tmpBox.CountTare5    ::TFloat
           , tmpBox.CountTare6    ::TFloat
           , tmpBox.CountTare7    ::TFloat
           , tmpBox.CountTare8    ::TFloat
           , tmpBox.CountTare9    ::TFloat
           , tmpBox.CountTare10   ::TFloat

           , tmpBox.BoxWeight1 ::TFloat, tmpBox.BoxWeight2 ::TFloat, tmpBox.BoxWeight3 ::TFloat, tmpBox.BoxWeight4 ::TFloat, tmpBox.BoxWeight5 ::TFloat
           , tmpBox.BoxWeight6 ::TFloat, tmpBox.BoxWeight7 ::TFloat, tmpBox.BoxWeight8 ::TFloat, tmpBox.BoxWeight9 ::TFloat, tmpBox.BoxWeight10 ::TFloat

           , (COALESCE (tmpBox.CountTare1,0) * COALESCE (tmpBox.BoxWeight1,0))   ::TFloat  AS  BoxWeight1_Tare
           , (COALESCE (tmpBox.CountTare2,0) * COALESCE (tmpBox.BoxWeight2,0))   ::TFloat  AS  BoxWeight2_Tare
           , (COALESCE (tmpBox.CountTare3,0) * COALESCE (tmpBox.BoxWeight3,0))   ::TFloat  AS  BoxWeight3_Tare
           , (COALESCE (tmpBox.CountTare4,0) * COALESCE (tmpBox.BoxWeight4,0))   ::TFloat  AS  BoxWeight4_Tare
           , (COALESCE (tmpBox.CountTare5,0) * COALESCE (tmpBox.BoxWeight5,0))   ::TFloat  AS  BoxWeight5_Tare
           , (COALESCE (tmpBox.CountTare6,0) * COALESCE (tmpBox.BoxWeight6,0))   ::TFloat  AS  BoxWeight6_Tare
           , (COALESCE (tmpBox.CountTare7,0) * COALESCE (tmpBox.BoxWeight7,0))   ::TFloat  AS  BoxWeight7_Tare
           , (COALESCE (tmpBox.CountTare8,0) * COALESCE (tmpBox.BoxWeight8,0))   ::TFloat  AS  BoxWeight8_Tare
           , (COALESCE (tmpBox.CountTare9,0) * COALESCE (tmpBox.BoxWeight9,0))   ::TFloat  AS  BoxWeight9_Tare
           , (COALESCE (tmpBox.CountTare10,0) * COALESCE (tmpBox.BoxWeight10,0)) ::TFloat  AS  BoxWeight10_Tare

           , (COALESCE (tmpBox.CountTare1,0) * COALESCE (tmpBox.BoxWeight1,0)
            + COALESCE (tmpBox.CountTare2,0) * COALESCE (tmpBox.BoxWeight2,0)
            + COALESCE (tmpBox.CountTare3,0) * COALESCE (tmpBox.BoxWeight3,0)
            + COALESCE (tmpBox.CountTare4,0) * COALESCE (tmpBox.BoxWeight4,0)
            + COALESCE (tmpBox.CountTare5,0) * COALESCE (tmpBox.BoxWeight5,0)
            + COALESCE (tmpBox.CountTare6,0) * COALESCE (tmpBox.BoxWeight6,0)
            + COALESCE (tmpBox.CountTare7,0) * COALESCE (tmpBox.BoxWeight7,0)
            + COALESCE (tmpBox.CountTare8,0) * COALESCE (tmpBox.BoxWeight8,0)
            + COALESCE (tmpBox.CountTare9,0) * COALESCE (tmpBox.BoxWeight9,0)
            + COALESCE (tmpBox.CountTare10,0) * COALESCE (tmpBox.BoxWeight10,0)) ::TFloat AS BoxWeightTotal

           ,(COALESCE (tmpBox.RealWeight,0) -
             (COALESCE (tmpBox.CountTare1,0) * COALESCE (tmpBox.BoxWeight1,0)
            + COALESCE (tmpBox.CountTare2,0) * COALESCE (tmpBox.BoxWeight2,0)
            + COALESCE (tmpBox.CountTare3,0) * COALESCE (tmpBox.BoxWeight3,0)
            + COALESCE (tmpBox.CountTare4,0) * COALESCE (tmpBox.BoxWeight4,0)
            + COALESCE (tmpBox.CountTare5,0) * COALESCE (tmpBox.BoxWeight5,0)
            + COALESCE (tmpBox.CountTare6,0) * COALESCE (tmpBox.BoxWeight6,0)
            + COALESCE (tmpBox.CountTare7,0) * COALESCE (tmpBox.BoxWeight7,0)
            + COALESCE (tmpBox.CountTare8,0) * COALESCE (tmpBox.BoxWeight8,0)
            + COALESCE (tmpBox.CountTare9,0) * COALESCE (tmpBox.BoxWeight9,0)
            + COALESCE (tmpBox.CountTare10,0) * COALESCE (tmpBox.BoxWeight10,0)) ) ::TFloat AS NettoWeight

           , tmpBox.RealWeight ::TFloat

           , tmpBox.BoxId_1, tmpBox.BoxId_2, tmpBox.BoxId_3, tmpBox.BoxId_4, tmpBox.BoxId_5
           , tmpBox.BoxId_6, tmpBox.BoxId_7, tmpBox.BoxId_8, tmpBox.BoxId_9, tmpBox.BoxId_10
           , tmpBox.BoxName_1 ::TVarChar, tmpBox.BoxName_2 ::TVarChar, tmpBox.BoxName_3 ::TVarChar, tmpBox.BoxName_4 ::TVarChar, tmpBox.BoxName_5 ::TVarChar
           , tmpBox.BoxName_6 ::TVarChar, tmpBox.BoxName_7 ::TVarChar, tmpBox.BoxName_8 ::TVarChar, tmpBox.BoxName_9 ::TVarChar, tmpBox.BoxName_10 ::TVarChar

       FROM tmpData AS tmpBox
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.25         *
*/

-- тест
--SELECT * FROM gpGet_MI_WeighingProduction_Box (inId:= 25173, inSession:= '2')
