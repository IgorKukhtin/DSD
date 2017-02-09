-- Function: lfSelect_Object_Juridical_byGroup (Integer)

DROP FUNCTION IF EXISTS lfSelect_Object_Juridical_byGroup (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Juridical_byGroup (IN inJuridicalGroupId Integer)
RETURNS TABLE (JuridicalId Integer)  
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY
     
     WITH RECURSIVE RecurObjectLink (ObjectId) AS
       (SELECT inJuridicalGroupId
       UNION
        SELECT ObjectLink.ObjectId
        FROM ObjectLink
             INNER JOIN RecurObjectLink ON RecurObjectLink.ObjectId = ObjectLink.ChildObjectId
        WHERE ObjectLink.DescId = zc_ObjectLink_JuridicalGroup_Parent()
       ) 
     SELECT ObjectLink.ObjectId AS JuridicalId
     FROM RecurObjectLink
          JOIN ObjectLink ON ObjectLink.ChildObjectId = RecurObjectLink.ObjectId
                         AND ObjectLink.DescId = zc_ObjectLink_Juridical_JuridicalGroup();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfSelect_Object_Juridical_byGroup (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.03.15                                        * вроде работает правильно)))             
*/

-- тест
-- SELECT * FROM lfSelect_Object_Juridical_byGroup (257163) AS lfSelect_Object_Juridical_byGroup JOIN Object ON Object.Id = lfSelect_Object_Juridical_byGroup.JuridicalId ORDER BY 4
-- SELECT * FROM lfSelect_Object_Juridical_byGroup (8362) AS lfSelect_Object_Juridical_byGroup JOIN Object ON Object.Id = lfSelect_Object_Juridical_byGroup.JuridicalId ORDER BY 4


