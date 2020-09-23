-- Function: gpSelect_Object_MemberMinus()

--DROP FUNCTION IF EXISTS gpSelect_Object_MemberMinus(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_MemberMinus(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberMinus(
    IN inisShowAll   Boolean ,      -- показать все физ.лица
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , BankAccountFromId Integer, BankAccountFromCode Integer, BankAccountFromName TVarChar
             , BankAccountToId Integer, BankAccountToCode Integer, BankAccountToName TVarChar
             , DetailPayment TVarChar, BankAccountTo TVarChar
             , TotalSumm TFloat, Summ TFloat
             , isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberMinus());

    IF inisShowAll = True
    THEN
     RETURN QUERY
     WITH 
     tmpMember AS (SELECT Object_Member.*
                   FROM Object AS Object_Member
                   WHERE Object_Member.DescId = zc_Object_Member()
                     AND Object_Member.isErased = FALSE
                   )

    , tmpMemberMinus AS (SELECT Object_MemberMinus.Id                 AS Id 
                              , Object_MemberMinus.ValueData          AS Name
                              
                              , MemberMinus_From.Id                   AS FromId
                              , MemberMinus_From.ObjectCode           AS FromCode
                              , MemberMinus_From.ValueData            AS FromName
                              , Object_To.Id                          AS ToId
                              , Object_To.ObjectCode                  AS ToCode
                              , Object_To.ValueData                   AS ToName
                              , Object_BankAccountFrom.Id             AS BankAccountFromId
                              , Object_BankAccountFrom.ObjectCode     AS BankAccountFromCode
                              , Object_BankAccountFrom.ValueData      AS BankAccountFromName
                              , Object_BankAccountTo.Id               AS BankAccountToId
                              , Object_BankAccountTo.ObjectCode       AS BankAccountToCode
                              , Object_BankAccountTo.ValueData        AS BankAccountToName
                              , ObjectString_DetailPayment.ValueData  AS DetailPayment
                              , ObjectString_BankAccountTo.ValueData  AS BankAccountTo
                              , COALESCE (ObjectFloat_TotalSumm.ValueData, 0) :: TFloat AS TotalSumm
                              , COALESCE (ObjectFloat_Summ.ValueData, 0)      :: TFloat AS Summ
                              , Object_MemberMinus.isErased           AS isErased
                          FROM Object AS Object_MemberMinus
                               LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_From
                                                    ON ObjectLink_MemberMinus_From.ObjectId = Object_MemberMinus.Id
                                                   AND ObjectLink_MemberMinus_From.DescId = zc_ObjectLink_MemberMinus_From()
                               FULL JOIN tmpMember ON tmpMember.Id = ObjectLink_MemberMinus_From.ChildObjectId
                               
                               LEFT JOIN Object AS MemberMinus_From ON MemberMinus_From.Id = COALESCE (ObjectLink_MemberMinus_From.ChildObjectId, tmpMember.Id)
                     
                               LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_To
                                                    ON ObjectLink_MemberMinus_To.ObjectId = Object_MemberMinus.Id
                                                   AND ObjectLink_MemberMinus_To.DescId = zc_ObjectLink_MemberMinus_To()
                               LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_MemberMinus_To.ChildObjectId          
                     
                               LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_BankAccountFrom
                                                    ON ObjectLink_MemberMinus_BankAccountFrom.ObjectId = Object_MemberMinus.Id
                                                   AND ObjectLink_MemberMinus_BankAccountFrom.DescId = zc_ObjectLink_MemberMinus_BankAccountFrom()
                               LEFT JOIN Object AS Object_BankAccountFrom ON Object_BankAccountFrom.Id = ObjectLink_MemberMinus_BankAccountFrom.ChildObjectId
                     
                               LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_BankAccountTo
                                                    ON ObjectLink_MemberMinus_BankAccountTo.ObjectId = Object_MemberMinus.Id
                                                   AND ObjectLink_MemberMinus_BankAccountTo.DescId = zc_ObjectLink_MemberMinus_BankAccountTo()
                               LEFT JOIN Object AS Object_BankAccountTo ON Object_BankAccountTo.Id = ObjectLink_MemberMinus_BankAccountTo.ChildObjectId
                     
                               LEFT JOIN ObjectString AS ObjectString_DetailPayment
                                                      ON ObjectString_DetailPayment.ObjectId = Object_MemberMinus.Id
                                                     AND ObjectString_DetailPayment.DescId = zc_ObjectString_MemberMinus_DetailPayment()
                     
                               LEFT JOIN ObjectString AS ObjectString_BankAccountTo
                                                      ON ObjectString_BankAccountTo.ObjectId = Object_MemberMinus.Id
                                                     AND ObjectString_BankAccountTo.DescId = zc_ObjectString_MemberMinus_BankAccountTo()
                     
                               LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm
                                                     ON ObjectFloat_TotalSumm.ObjectId = Object_MemberMinus.Id
                                                    AND ObjectFloat_TotalSumm.DescId = zc_ObjectFloat_MemberMinus_TotalSumm()
                     
                               LEFT JOIN ObjectFloat AS ObjectFloat_Summ
                                                     ON ObjectFloat_Summ.ObjectId = Object_MemberMinus.Id
                                                    AND ObjectFloat_Summ.DescId = zc_ObjectFloat_MemberMinus_Summ()
                     
                          WHERE Object_MemberMinus.DescId = zc_Object_MemberMinus()
                          )

        SELECT tmpMemberMinus.Id
             , tmpMemberMinus.Name
             
             , COALESCE (tmpMemberMinus.FromId, tmpMember.Id)           AS FromId
             , COALESCE (tmpMemberMinus.FromCode, tmpMember.ObjectCode) AS FromCode 
             , COALESCE (tmpMemberMinus.FromName, tmpMember.ValueData)  AS FromName
             
             , tmpMemberMinus.ToId
             , tmpMemberMinus.ToCode
             , tmpMemberMinus.ToName
    
             , tmpMemberMinus.BankAccountFromId
             , tmpMemberMinus.BankAccountFromCode
             , tmpMemberMinus.BankAccountFromName
    
             , tmpMemberMinus.BankAccountToId
             , tmpMemberMinus.BankAccountToCode
             , tmpMemberMinus.BankAccountToName
               
             , tmpMemberMinus.DetailPayment
             , tmpMemberMinus.BankAccountTo
    
             , tmpMemberMinus.TotalSumm
             , tmpMemberMinus.Summ
    
             , tmpMemberMinus.isErased
        FROM tmpMember
             FULL JOIN tmpMemberMinus ON tmpMemberMinus.FromId = tmpMember.Id
        ;  

    ELSE
        RETURN QUERY 
     SELECT 
           Object_MemberMinus.Id                 AS Id 
         , Object_MemberMinus.ValueData          AS Name
         
         , MemberMinus_From.Id                   AS FromId
         , MemberMinus_From.ObjectCode           AS FromCode
         , MemberMinus_From.ValueData            AS FromName
         
         , Object_To.Id                          AS ToId
         , Object_To.ObjectCode                  AS ToCode
         , Object_To.ValueData                   AS ToName

         , Object_BankAccountFrom.Id             AS BankAccountFromId
         , Object_BankAccountFrom.ObjectCode     AS BankAccountFromCode
         , Object_BankAccountFrom.ValueData      AS BankAccountFromName

         , Object_BankAccountTo.Id               AS BankAccountToId
         , Object_BankAccountTo.ObjectCode       AS BankAccountToCode
         , Object_BankAccountTo.ValueData        AS BankAccountToName
                   
         , ObjectString_DetailPayment.ValueData  AS DetailPayment
         , ObjectString_BankAccountTo.ValueData  AS BankAccountTo

         , COALESCE (ObjectFloat_TotalSumm.ValueData, 0) :: TFloat AS TotalSumm
         , COALESCE (ObjectFloat_Summ.ValueData, 0)      :: TFloat AS Summ

         , Object_MemberMinus.isErased           AS isErased
         
     FROM Object AS Object_MemberMinus
          LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_From
                               ON ObjectLink_MemberMinus_From.ObjectId = Object_MemberMinus.Id
                              AND ObjectLink_MemberMinus_From.DescId = zc_ObjectLink_MemberMinus_From()
          LEFT JOIN Object AS MemberMinus_From ON MemberMinus_From.Id = ObjectLink_MemberMinus_From.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_To
                               ON ObjectLink_MemberMinus_To.ObjectId = Object_MemberMinus.Id
                              AND ObjectLink_MemberMinus_To.DescId = zc_ObjectLink_MemberMinus_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_MemberMinus_To.ChildObjectId          

          LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_BankAccountFrom
                               ON ObjectLink_MemberMinus_BankAccountFrom.ObjectId = Object_MemberMinus.Id
                              AND ObjectLink_MemberMinus_BankAccountFrom.DescId = zc_ObjectLink_MemberMinus_BankAccountFrom()
          LEFT JOIN Object AS Object_BankAccountFrom ON Object_BankAccountFrom.Id = ObjectLink_MemberMinus_BankAccountFrom.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_BankAccountTo
                               ON ObjectLink_MemberMinus_BankAccountTo.ObjectId = Object_MemberMinus.Id
                              AND ObjectLink_MemberMinus_BankAccountTo.DescId = zc_ObjectLink_MemberMinus_BankAccountTo()
          LEFT JOIN Object AS Object_BankAccountTo ON Object_BankAccountTo.Id = ObjectLink_MemberMinus_BankAccountTo.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_DetailPayment
                                 ON ObjectString_DetailPayment.ObjectId = Object_MemberMinus.Id
                                AND ObjectString_DetailPayment.DescId = zc_ObjectString_MemberMinus_DetailPayment()

          LEFT JOIN ObjectString AS ObjectString_BankAccountTo
                                 ON ObjectString_BankAccountTo.ObjectId = Object_MemberMinus.Id
                                AND ObjectString_BankAccountTo.DescId = zc_ObjectString_MemberMinus_BankAccountTo()

          LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm
                                ON ObjectFloat_TotalSumm.ObjectId = Object_MemberMinus.Id
                               AND ObjectFloat_TotalSumm.DescId = zc_ObjectFloat_MemberMinus_TotalSumm()

          LEFT JOIN ObjectFloat AS ObjectFloat_Summ
                                ON ObjectFloat_Summ.ObjectId = Object_MemberMinus.Id
                               AND ObjectFloat_Summ.DescId = zc_ObjectFloat_MemberMinus_Summ()

     WHERE Object_MemberMinus.DescId = zc_Object_MemberMinus();  
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberMinus (true, zfCalc_UserAdmin())
