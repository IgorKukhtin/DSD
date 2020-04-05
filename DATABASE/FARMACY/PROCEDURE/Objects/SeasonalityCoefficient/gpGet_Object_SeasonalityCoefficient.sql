-- Function: gpGet_Object_SeasonalityCoefficient()

DROP FUNCTION IF EXISTS gpGet_Object_SeasonalityCoefficient(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_SeasonalityCoefficient(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Koeff1 TFloat
             , Koeff2 TFloat
             , Koeff3 TFloat
             , Koeff4 TFloat
             , Koeff5 TFloat
             , Koeff6 TFloat
             , Koeff7 TFloat
             , Koeff8 TFloat
             , Koeff9 TFloat
             , Koeff10 TFloat
             , Koeff11 TFloat
             , Koeff12 TFloat
             , isErased Boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   
   IF COALESCE(inId, 0) = 0
   THEN
     IF EXISTS(SELECT 1 FROM Object WHERE Object.DescId = zc_Object_SeasonalityCoefficient())
     THEN
       inId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_SeasonalityCoefficient());
     ELSE
       inId := gpInsertUpdate_Object_SeasonalityCoefficient(0, lfGet_ObjectCode(0, zc_Object_SeasonalityCoefficient()), 'Коэффициента сезонности', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, inSession);   
     END IF;
   END IF;

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_SeasonalityCoefficient()) AS Code
           , CAST ('Коэффициента сезонности' as TVarChar)   AS Name
           , CAST (1 AS TFloat)      AS Koeff1
           , CAST (1 AS TFloat)      AS Koeff2
           , CAST (1 AS TFloat)      AS Koeff3
           , CAST (1 AS TFloat)      AS Koeff4
           , CAST (1 AS TFloat)      AS Koeff5
           , CAST (1 AS TFloat)      AS Koeff6
           , CAST (1 AS TFloat)      AS Koeff7
           , CAST (1 AS TFloat)      AS Koeff8
           , CAST (1 AS TFloat)      AS Koeff9
           , CAST (1 AS TFloat)      AS Koeff10
           , CAST (1 AS TFloat)      AS Koeff11
           , CAST (0 AS TFloat)      AS Koeff12
           , CAST (FALSE AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_SeasonalityCoefficient.Id         AS Id
           , Object_SeasonalityCoefficient.ObjectCode AS Code
           , Object_SeasonalityCoefficient.ValueData  AS Name

           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff1.ValueData, 1) :: TFloat AS Koeff1
           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff2.ValueData, 1) :: TFloat AS Koeff2
           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff3.ValueData, 1) :: TFloat AS Koeff3
           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff4.ValueData, 1) :: TFloat AS Koeff4
           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff5.ValueData, 1) :: TFloat AS Koeff5
           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff6.ValueData, 1) :: TFloat AS Koeff6
           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff7.ValueData, 1) :: TFloat AS Koeff7
           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff8.ValueData, 1) :: TFloat AS Koeff8
           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff9.ValueData, 1) :: TFloat AS Koeff9
           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff10.ValueData, 1) :: TFloat AS Koeff10
           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff11.ValueData, 1) :: TFloat AS Koeff11
           , COALESCE (ObjectFloat_SeasonalityCoefficient_Koeff12.ValueData, 1) :: TFloat AS Koeff12

           , Object_SeasonalityCoefficient.isErased   AS isErased
       FROM Object AS Object_SeasonalityCoefficient
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff1
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff1.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff1.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff1()
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff2
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff2.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff2.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff2()
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff3
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff3.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff3.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff3()
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff4
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff4.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff4.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff4()
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff5
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff5.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff5.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff5()
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff6
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff6.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff6.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff6()
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff7
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff7.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff7.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff7()
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff8
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff8.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff8.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff8()
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff9
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff9.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff9.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff9()
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff10
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff10.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff10.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff10()
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff11
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff11.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff11.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff11()
            LEFT JOIN ObjectFloat AS ObjectFloat_SeasonalityCoefficient_Koeff12
                                  ON ObjectFloat_SeasonalityCoefficient_Koeff12.ObjectId = Object_SeasonalityCoefficient.Id 
                                 AND ObjectFloat_SeasonalityCoefficient_Koeff12.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff12()
       WHERE Object_SeasonalityCoefficient.Id = inId;

   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.04.20                                                       * add isGoodsReprice
*/

-- тест select * from gpGet_Object_SeasonalityCoefficient(0, '3');