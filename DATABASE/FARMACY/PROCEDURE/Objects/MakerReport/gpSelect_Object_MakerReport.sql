-- Function: gpSelect_Object_MakerReport()

DROP FUNCTION IF EXISTS gpSelect_Object_MakerReport(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MakerReport(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , MakerId Integer, MakerCode Integer, MakerName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , isErased   Boolean
             ) AS
$BODY$BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Maker());

     RETURN QUERY  
       SELECT 
             Object_MakerReport.Id        AS Id
          
           , Object_Maker.Id              AS MakerId
           , Object_Maker.ObjectCode      AS MakerCode
           , Object_Maker.ValueData       AS MakerName

           , Object_Juridical.Id          AS JuridicalId
           , Object_Juridical.ObjectCode  AS JuridicalCode
           , Object_Juridical.ValueData   AS JuridicalName

           , Object_MakerReport.isErased  AS isErased
           
       FROM Object AS Object_MakerReport
   
           LEFT JOIN ObjectLink AS ObjectLink_Maker 
                                ON ObjectLink_Maker.ObjectId = Object_MakerReport.Id 
                               AND ObjectLink_Maker.DescId = zc_ObjectLink_MakerReport_Maker()
           LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = ObjectLink_Maker.ChildObjectId              

           LEFT JOIN ObjectLink AS ObjectLink_Juridical 
                                ON ObjectLink_Juridical.ObjectId = Object_MakerReport.Id 
                               AND ObjectLink_Juridical.DescId = zc_ObjectLink_MakerReport_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId 

     WHERE Object_MakerReport.DescId = zc_Object_MakerReport();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.01.19         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_MakerReport('2')