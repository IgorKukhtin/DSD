-- Function: gpSelect_Object_ContractÑonditionKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractÑonditionKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractÑonditionKind(
    IN inSession        TVarChar       -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- ïğîâåğêà ïğàâ ïîëüçîâàòåëÿ íà âûçîâ ïğîöåäóğû
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractÑonditionKind());

   RETURN QUERY 
   SELECT
        Object_ContractÑonditionKind.Id           AS Id 
      , Object_ContractÑonditionKind.ObjectCode   AS Code
      , Object_ContractÑonditionKind.ValueData    AS NAME
      
      , Object_ContractÑonditionKind.isErased     AS isErased
      
   FROM OBJECT AS Object_ContractÑonditionKind
                              
   WHERE Object_ContractÑonditionKind.DescId = zc_Object_ContractÑonditionKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractÑonditionKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ÈÑÒÎĞÈß ĞÀÇĞÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎĞ
               Ôåëîíşê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 16.11.13         *

*/

-- òåñò
-- SELECT * FROM gpSelect_Object_ContractÑonditionKind('2')
