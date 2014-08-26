-- View: Object_Currency_View

-- DROP VIEW IF EXISTS Object_Currency_View;

CREATE OR REPLACE VIEW Object_Currency_View AS
   SELECT 
     Object.Id          AS Id
   , Object.ObjectCode  AS Code
   , Object.ValueData   AS Name
   , Object.isErased    AS isErased
   , ObjectString.ValueData AS InternalName
   FROM Object
   JOIN ObjectString
     ON ObjectString.ObjectId = Object.Id
    AND ObjectString.DescId = zc_objectString_Currency_InternalName()
   WHERE Object.DescId = zc_Object_Currency();


ALTER TABLE Object_Currency_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.12.13                         *
 15.11.13                         *
*/

-- ����
-- SELECT * FROM Object_Currency_View
