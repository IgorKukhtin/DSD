-- Function: gpGet_Object_ProdModel()

DROP FUNCTION IF EXISTS gpGet_Object_ProdModel(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdModel(
    IN inId          Integer,       -- �������� �������� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Length TFloat, Beam TFloat, Height TFloat
             , Weight TFloat, Fuel TFloat, Speed TFloat, Seating TFloat
             , Comment TVarChar
             ) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ProdModel());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ProdModel())   AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 AS TFloat)     AS Length
           , CAST (0 AS TFloat)     AS Beam
           , CAST (0 AS TFloat)     AS Height
           , CAST (0 AS TFloat)     AS Weight
           , CAST (0 AS TFloat)     AS Fuel
           , CAST (0 AS TFloat)     AS Speed
           , CAST (0 AS TFloat)     AS Seating
           , CAST ('' AS TVarChar)  AS Comment
          ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_ProdModel.Id             AS Id 
         , Object_ProdModel.ObjectCode     AS Code
         , Object_ProdModel.ValueData      AS Name

         , ObjectFloat_Length.ValueData    AS Length
         , ObjectFloat_Beam.ValueData      AS Beam
         , ObjectFloat_Height.ValueData    AS Height
         , ObjectFloat_Weight.ValueData    AS Weight
         , ObjectFloat_Fuel.ValueData      AS Fuel
         , ObjectFloat_Speed.ValueData     AS Speed
         , ObjectFloat_Seating.ValueData   AS Seating
         , ObjectString_Comment.ValueData  AS Comment
        
     FROM Object AS Object_ProdModel
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdModel.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdModel_Comment()  

          LEFT JOIN ObjectFloat AS ObjectFloat_Length
                                ON ObjectFloat_Length.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Length.DescId = zc_ObjectFloat_ProdModel_Length()

          LEFT JOIN ObjectFloat AS ObjectFloat_Beam
                                ON ObjectFloat_Beam.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Beam.DescId = zc_ObjectFloat_ProdModel_Beam()

          LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                ON ObjectFloat_Height.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Height.DescId = zc_ObjectFloat_ProdModel_Height()

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_ProdModel_Weight()

          LEFT JOIN ObjectFloat AS ObjectFloat_Fuel
                                ON ObjectFloat_Fuel.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Fuel.DescId = zc_ObjectFloat_ProdModel_Fuel()

          LEFT JOIN ObjectFloat AS ObjectFloat_Speed
                                ON ObjectFloat_Speed.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Speed.DescId = zc_ObjectFloat_ProdModel_Speed()

          LEFT JOIN ObjectFloat AS ObjectFloat_Seating
                                ON ObjectFloat_Seating.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Seating.DescId = zc_ObjectFloat_ProdModel_Seating()

       WHERE Object_ProdModel.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpGet_Object_ProdModel(0, '2')