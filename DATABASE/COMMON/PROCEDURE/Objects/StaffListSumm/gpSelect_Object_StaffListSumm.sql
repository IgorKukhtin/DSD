-- Function: gpSelect_Object_StaffListSumm (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StaffListSumm (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_StaffListSumm (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StaffListSumm(
    IN inIsShowAll   Boolean,       --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Value TFloat
             , Comment TVarChar
             , StaffListId Integer, StaffListName TVarChar                
             , StaffListMasterId Integer, StaffListMasterCode Integer
             , StaffListSummKindId Integer, StaffListSummKindName TVarChar, SummKindComment TVarChar
             , isErased boolean 
             , UpdateName TVarChar, UpdateDate TDateTime
             ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_StaffListSumm());

   RETURN QUERY 
     WITH
     tmpObject AS (SELECT Object.*
                   FROM Object
                   WHERE Object.DescId = zc_Object_StaffListSumm()  
                    AND (Object.isErased = FALSE OR inIsShowAll = TRUE)
                   )
      
   , tmpProtocol AS (SELECT tmp.ObjectId
                          , tmp.UserId
                          , Object_User.ValueData AS UserName
                          , tmp.OperDate
                     FROM (SELECT ObjectProtocol.*
                                  -- № п/п
                                , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                           FROM ObjectProtocol
                           WHERE ObjectProtocol.ObjectId IN (SELECT tmpObject.Id FROM tmpObject)
                           ) AS tmp 
                           LEFT JOIN Object AS Object_User ON Object_User.Id = tmp.UserId  
                     WHERE tmp.Ord = 1
                     )

     SELECT 
           Object_StaffListSumm.Id        AS Id
 
         , ObjectFloat_Value.ValueData     AS Value  
         , ObjectString_Comment.ValueData  AS Comment
                                                        
         , Object_StaffList.Id          AS StaffListId
         , Object_StaffList.ValueData   AS StaffListName

         , Object_StaffListMaster.Id          AS StaffListMasterId
         , Object_StaffListMaster.ObjectCode  AS StaffListMasterCode

         , Object_StaffListSummKind.Id          AS StaffListSummKindId
         , Object_StaffListSummKind.ValueData   AS StaffListSummKindName
         , ObjectString_StaffListSummKind_Comment.ValueData  AS SummKindComment

         , Object_StaffListSumm.isErased AS isErased

         , tmpProtocol.UserName    ::TVarChar  AS UpdateName
         , tmpProtocol.OperDate    ::TDateTime AS UpdateDate
     FROM tmpObject AS Object_StaffListSumm
     
          LEFT JOIN ObjectLink AS ObjectLink_StaffListSumm_StaffList
                               ON ObjectLink_StaffListSumm_StaffList.ObjectId = Object_StaffListSumm.Id
                              AND ObjectLink_StaffListSumm_StaffList.DescId = zc_ObjectLink_StaffListSumm_StaffList()
          LEFT JOIN Object AS Object_StaffList ON Object_StaffList.Id = ObjectLink_StaffListSumm_StaffList.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_StaffListSumm_StaffListMaster
                               ON ObjectLink_StaffListSumm_StaffListMaster.ObjectId = Object_StaffListSumm.Id
                              AND ObjectLink_StaffListSumm_StaffListMaster.DescId = zc_ObjectLink_StaffListSumm_StaffListMaster()
          LEFT JOIN Object AS Object_StaffListMaster ON Object_StaffListMaster.Id = ObjectLink_StaffListSumm_StaffListMaster.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_StaffListSumm_StaffListSummKind
                               ON ObjectLink_StaffListSumm_StaffListSummKind.ObjectId = Object_StaffListSumm.Id
                              AND ObjectLink_StaffListSumm_StaffListSummKind.DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind()
          LEFT JOIN Object AS Object_StaffListSummKind ON Object_StaffListSummKind.Id = ObjectLink_StaffListSumm_StaffListSummKind.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_StaffListSummKind_Comment ON ObjectString_StaffListSummKind_Comment.ObjectId = Object_StaffListSummKind.Id 
                                                                          AND ObjectString_StaffListSummKind_Comment.DescId = zc_ObjectString_StaffListSummKind_Comment()   

          LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                ON ObjectFloat_Value.ObjectId = Object_StaffListSumm.Id 
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_StaffListSumm_Value()
          
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_StaffListSumm.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_StaffListSumm_Comment()

          LEFT JOIN tmpProtocol ON tmpProtocol.ObjectId = Object_StaffListSumm.Id
     ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Object_StaffListSumm (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.17         * add inIsShowAll
 30.11.13                                        * add SummKindComment
 22.11.13                                        * Cyr1251
 30.10.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StaffListSumm (False,'2')