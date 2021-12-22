-- Function: gpSelect_Object_MemberMinus()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberMinus(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_MemberMinus(Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_MemberMinus(Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberMinus(
    IN inisShowAll   Boolean ,      -- показать все физ.лица
    IN inisErased    Boolean ,      -- показать удаленные
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar, INN_From TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar, ToShort TVarChar, INN_to TVarChar, DescName_to TVarChar
             , BankAccountFromId Integer, BankAccountFromCode Integer, BankAccountFromName TVarChar, BankName_From TVarChar
             , BankAccountToId Integer, BankAccountToCode Integer, BankAccountToName TVarChar, BankName_To TVarChar
             , DetailPayment TVarChar, BankAccountTo TVarChar
             , Number TVarChar
             , TotalSumm TFloat, Summ TFloat
             , Tax TFloat
             , isChild Boolean
             , isToShort Boolean
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
                        , ObjectString_INN.ValueData AS INN_from
                   FROM Object AS Object_Member
                        LEFT JOIN ObjectString AS ObjectString_INN
                                               ON ObjectString_INN.ObjectId = Object_Member.Id
                                              AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
                   WHERE Object_Member.DescId = zc_Object_Member()
                     AND Object_Member.isErased = FALSE
                   )

    , tmpMemberMinus AS (SELECT Object_MemberMinus.Id                 AS Id 
                              , Object_MemberMinus.ValueData          AS Name
                              
                              , MemberMinus_From.Id                   AS FromId
                              , MemberMinus_From.ObjectCode           AS FromCode
                              , MemberMinus_From.ValueData            AS FromName
                              , ObjectString_INN_from.ValueData       AS INN_from
                              , Object_To.Id                          AS ToId
                              , Object_To.ObjectCode                  AS ToCode
                              , Object_To.ValueData                   AS ToName
                              , ObjectDesc_To.ItemName                AS DescName_to
                              , ObjectString_ToShort.ValueData        AS ToShort
                              , CASE WHEN Object_To.DescId = zc_Object_Juridical() THEN ObjectHistory_JuridicalDetails_View.OKPO
                                     ELSE ObjectString_INN_to.ValueData
                                END                                   AS INN_to
                              
                              , Object_BankAccountFrom.Id             AS BankAccountFromId
                              , Object_BankAccountFrom.ObjectCode     AS BankAccountFromCode
                              , Object_BankAccountFrom.ValueData      AS BankAccountFromName
                              , Object_Bank_from.ValueData            AS BankName_From
                              , Object_BankAccountTo.Id               AS BankAccountToId
                              , Object_BankAccountTo.ObjectCode       AS BankAccountToCode
                              , Object_BankAccountTo.ValueData        AS BankAccountToName
                              , Object_Bank_to.ValueData              AS BankName_To
                              , ObjectString_DetailPayment.ValueData  AS DetailPayment
                              , ObjectString_BankAccountTo.ValueData  AS BankAccountTo
                              , COALESCE (ObjectString_Number.ValueData,'')::TVarChar   AS Number
                              , COALESCE (ObjectFloat_TotalSumm.ValueData, 0) :: TFloat AS TotalSumm
                              , COALESCE (ObjectFloat_Summ.ValueData, 0)      :: TFloat AS Summ
                              , COALESCE (ObjectFloat_Tax.ValueData, 0)       :: TFloat AS Tax
                              , COALESCE (ObjectBoolean_Child.ValueData, FALSE) :: Boolean AS isChild
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
                               LEFT JOIN ObjectDesc AS ObjectDesc_To ON ObjectDesc_To.Id = Object_To.DescId
                     
                               LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_BankAccountFrom
                                                    ON ObjectLink_MemberMinus_BankAccountFrom.ObjectId = Object_MemberMinus.Id
                                                   AND ObjectLink_MemberMinus_BankAccountFrom.DescId = zc_ObjectLink_MemberMinus_BankAccountFrom()
                               LEFT JOIN Object AS Object_BankAccountFrom ON Object_BankAccountFrom.Id = ObjectLink_MemberMinus_BankAccountFrom.ChildObjectId
                     
                               LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_BankAccountTo
                                                    ON ObjectLink_MemberMinus_BankAccountTo.ObjectId = Object_MemberMinus.Id
                                                   AND ObjectLink_MemberMinus_BankAccountTo.DescId = zc_ObjectLink_MemberMinus_BankAccountTo()
                               LEFT JOIN Object AS Object_BankAccountTo ON Object_BankAccountTo.Id = ObjectLink_MemberMinus_BankAccountTo.ChildObjectId

                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Child
                                                       ON ObjectBoolean_Child.ObjectId = Object_MemberMinus.Id
                                                      AND ObjectBoolean_Child.DescId = zc_ObjectBoolean_MemberMinus_Child()

                               LEFT JOIN ObjectString AS ObjectString_ToShort
                                                      ON ObjectString_ToShort.ObjectId = Object_MemberMinus.Id
                                                     AND ObjectString_ToShort.DescId = zc_ObjectString_MemberMinus_ToShort()

                               LEFT JOIN ObjectString AS ObjectString_DetailPayment
                                                      ON ObjectString_DetailPayment.ObjectId = Object_MemberMinus.Id
                                                     AND ObjectString_DetailPayment.DescId = zc_ObjectString_MemberMinus_DetailPayment()
                     
                               LEFT JOIN ObjectString AS ObjectString_BankAccountTo
                                                      ON ObjectString_BankAccountTo.ObjectId = Object_MemberMinus.Id
                                                     AND ObjectString_BankAccountTo.DescId = zc_ObjectString_MemberMinus_BankAccountTo()

                               LEFT JOIN ObjectString AS ObjectString_Number
                                                      ON ObjectString_Number.ObjectId = Object_MemberMinus.Id
                                                     AND ObjectString_Number.DescId = zc_ObjectString_MemberMinus_Number()

                               LEFT JOIN ObjectString AS ObjectString_INN_from
                                                      ON ObjectString_INN_from.ObjectId = MemberMinus_From.Id
                                                     AND ObjectString_INN_from.DescId = zc_ObjectString_Member_INN()

                               LEFT JOIN ObjectString AS ObjectString_INN_to
                                                      ON ObjectString_INN_to.ObjectId = Object_To.Id
                                                     AND ObjectString_INN_to.DescId IN (zc_ObjectString_MemberExternal_INN(), zc_ObjectString_Member_INN())
                                                     AND Object_To.DescId <> zc_Object_Juridical()
                               LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_To.Id
                                                                            AND Object_To.DescId = zc_Object_Juridical()

                               LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm
                                                     ON ObjectFloat_TotalSumm.ObjectId = Object_MemberMinus.Id
                                                    AND ObjectFloat_TotalSumm.DescId = zc_ObjectFloat_MemberMinus_TotalSumm()
                     
                               LEFT JOIN ObjectFloat AS ObjectFloat_Summ
                                                     ON ObjectFloat_Summ.ObjectId = Object_MemberMinus.Id
                                                    AND ObjectFloat_Summ.DescId = zc_ObjectFloat_MemberMinus_Summ()

                               LEFT JOIN ObjectFloat AS ObjectFloat_Tax
                                                     ON ObjectFloat_Tax.ObjectId = Object_MemberMinus.Id
                                                    AND ObjectFloat_Tax.DescId = zc_ObjectFloat_MemberMinus_Tax()

                               LEFT JOIN ObjectLink AS ObjectLink_Bank_From
                                                    ON ObjectLink_Bank_From.ObjectId = Object_BankAccountFrom.Id
                                                   AND ObjectLink_Bank_From.DescId = zc_ObjectLink_BankAccount_Bank()
                               LEFT JOIN Object AS Object_Bank_from ON Object_Bank_from.Id = ObjectLink_Bank_From.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Bank_To
                                                    ON ObjectLink_Bank_To.ObjectId = Object_BankAccountTo.Id
                                                   AND ObjectLink_Bank_To.DescId = zc_ObjectLink_BankAccount_Bank()
                               LEFT JOIN Object AS Object_Bank_to ON Object_Bank_to.Id = ObjectLink_Bank_To.ChildObjectId

                          WHERE Object_MemberMinus.DescId = zc_Object_MemberMinus()
                            AND (Object_MemberMinus.isErased = FALSE OR inisErased = TRUE)
                          )

        SELECT tmpMemberMinus.Id
             , tmpMemberMinus.Name
             
             , COALESCE (tmpMemberMinus.FromId, tmpMember.Id)           AS FromId
             , COALESCE (tmpMemberMinus.FromCode, tmpMember.ObjectCode) AS FromCode 
             , COALESCE (tmpMemberMinus.FromName, tmpMember.ValueData)  AS FromName
             , COALESCE (tmpMemberMinus.INN_from, tmpMember.INN_from)   AS INN_from
             
             , tmpMemberMinus.ToId
             , tmpMemberMinus.ToCode
             , tmpMemberMinus.ToName
             , tmpMemberMinus.ToShort
             , tmpMemberMinus.INN_to
             , tmpMemberMinus.DescName_to
    
             , tmpMemberMinus.BankAccountFromId
             , tmpMemberMinus.BankAccountFromCode
             , tmpMemberMinus.BankAccountFromName
             , tmpMemberMinus.BankName_From
    
             , tmpMemberMinus.BankAccountToId
             , tmpMemberMinus.BankAccountToCode
             , tmpMemberMinus.BankAccountToName
             , tmpMemberMinus.BankName_To
               
             , tmpMemberMinus.DetailPayment
             , tmpMemberMinus.BankAccountTo
             , tmpMemberMinus.Number ::TVarChar
    
             , tmpMemberMinus.TotalSumm
             , tmpMemberMinus.Summ
             , tmpMemberMinus.Tax ::TFloat
             
             , COALESCE (tmpMemberMinus.isChild, FALSE) ::Boolean AS isChild
             , CASE WHEN LENGTH (tmpMemberMinus.ToName) > 36 THEN TRUE ELSE FALSE END :: Boolean AS isToShort
    
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
             , ObjectString_INN_from.ValueData       AS INN_from
             
             , Object_To.Id                          AS ToId
             , Object_To.ObjectCode                  AS ToCode
             , Object_To.ValueData                   AS ToName
             , ObjectString_ToShort.ValueData        AS ToShort
             , CASE WHEN Object_To.DescId = zc_Object_Juridical() THEN ObjectHistory_JuridicalDetails_View.OKPO
                    ELSE ObjectString_INN_to.ValueData
               END                                   AS INN_to
             , ObjectDesc_To.ItemName                AS DescName_to
    
             , Object_BankAccountFrom.Id             AS BankAccountFromId
             , Object_BankAccountFrom.ObjectCode     AS BankAccountFromCode
             , Object_BankAccountFrom.ValueData      AS BankAccountFromName
             , Object_Bank_from.ValueData            AS BankName_From
    
             , Object_BankAccountTo.Id               AS BankAccountToId
             , Object_BankAccountTo.ObjectCode       AS BankAccountToCode
             , Object_BankAccountTo.ValueData        AS BankAccountToName
             , Object_Bank_to.ValueData              AS BankName_To
                       
             , ObjectString_DetailPayment.ValueData  AS DetailPayment
             , ObjectString_BankAccountTo.ValueData  AS BankAccountTo
             , COALESCE (ObjectString_Number.ValueData,'')::TVarChar   AS Number
    
             , COALESCE (ObjectFloat_TotalSumm.ValueData, 0) :: TFloat AS TotalSumm
             , COALESCE (ObjectFloat_Summ.ValueData, 0)      :: TFloat AS Summ
             , COALESCE (ObjectFloat_Tax.ValueData, 0)       :: TFloat AS Tax

             , COALESCE (ObjectBoolean_Child.ValueData, FALSE) :: Boolean AS isChild
             , CASE WHEN LENGTH (Object_To.ValueData) > 36 THEN TRUE ELSE FALSE END :: Boolean AS isToShort
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
              LEFT JOIN ObjectDesc AS ObjectDesc_To ON ObjectDesc_To.Id = Object_To.DescId

              LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_BankAccountFrom
                                   ON ObjectLink_MemberMinus_BankAccountFrom.ObjectId = Object_MemberMinus.Id
                                  AND ObjectLink_MemberMinus_BankAccountFrom.DescId = zc_ObjectLink_MemberMinus_BankAccountFrom()
              LEFT JOIN Object AS Object_BankAccountFrom ON Object_BankAccountFrom.Id = ObjectLink_MemberMinus_BankAccountFrom.ChildObjectId

              LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_BankAccountTo
                                   ON ObjectLink_MemberMinus_BankAccountTo.ObjectId = Object_MemberMinus.Id
                                  AND ObjectLink_MemberMinus_BankAccountTo.DescId = zc_ObjectLink_MemberMinus_BankAccountTo()
              LEFT JOIN Object AS Object_BankAccountTo ON Object_BankAccountTo.Id = ObjectLink_MemberMinus_BankAccountTo.ChildObjectId

              LEFT JOIN ObjectBoolean AS ObjectBoolean_Child
                                      ON ObjectBoolean_Child.ObjectId = Object_MemberMinus.Id
                                     AND ObjectBoolean_Child.DescId = zc_ObjectBoolean_MemberMinus_Child()

              LEFT JOIN ObjectString AS ObjectString_ToShort
                                     ON ObjectString_ToShort.ObjectId = Object_MemberMinus.Id
                                    AND ObjectString_ToShort.DescId = zc_ObjectString_MemberMinus_ToShort()

              LEFT JOIN ObjectString AS ObjectString_DetailPayment
                                     ON ObjectString_DetailPayment.ObjectId = Object_MemberMinus.Id
                                    AND ObjectString_DetailPayment.DescId = zc_ObjectString_MemberMinus_DetailPayment()

              LEFT JOIN ObjectString AS ObjectString_BankAccountTo
                                     ON ObjectString_BankAccountTo.ObjectId = Object_MemberMinus.Id
                                    AND ObjectString_BankAccountTo.DescId = zc_ObjectString_MemberMinus_BankAccountTo()

              LEFT JOIN ObjectString AS ObjectString_Number
                                     ON ObjectString_Number.ObjectId = Object_MemberMinus.Id
                                    AND ObjectString_Number.DescId = zc_ObjectString_MemberMinus_Number()

              LEFT JOIN ObjectString AS ObjectString_INN_from
                                     ON ObjectString_INN_from.ObjectId = MemberMinus_From.Id
                                    AND ObjectString_INN_from.DescId = zc_ObjectString_Member_INN()

              LEFT JOIN ObjectString AS ObjectString_INN_to
                                     ON ObjectString_INN_to.ObjectId = Object_To.Id
                                    AND ObjectString_INN_to.DescId IN (zc_ObjectString_MemberExternal_INN(), zc_ObjectString_Member_INN())
                                    AND Object_To.DescId <> zc_Object_Juridical()
              LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_To.Id
                                                           AND Object_To.DescId = zc_Object_Juridical()

              LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm
                                    ON ObjectFloat_TotalSumm.ObjectId = Object_MemberMinus.Id
                                   AND ObjectFloat_TotalSumm.DescId = zc_ObjectFloat_MemberMinus_TotalSumm()

              LEFT JOIN ObjectFloat AS ObjectFloat_Summ
                                    ON ObjectFloat_Summ.ObjectId = Object_MemberMinus.Id
                                   AND ObjectFloat_Summ.DescId = zc_ObjectFloat_MemberMinus_Summ()

              LEFT JOIN ObjectFloat AS ObjectFloat_Tax
                                    ON ObjectFloat_Tax.ObjectId = Object_MemberMinus.Id
                                   AND ObjectFloat_Tax.DescId = zc_ObjectFloat_MemberMinus_Tax()

              LEFT JOIN ObjectLink AS ObjectLink_Bank_From
                                   ON ObjectLink_Bank_From.ObjectId = Object_BankAccountFrom.Id
                                  AND ObjectLink_Bank_From.DescId = zc_ObjectLink_BankAccount_Bank()
              LEFT JOIN Object AS Object_Bank_from ON Object_Bank_from.Id = ObjectLink_Bank_From.ChildObjectId

              LEFT JOIN ObjectLink AS ObjectLink_Bank_To
                                   ON ObjectLink_Bank_To.ObjectId = Object_BankAccountTo.Id
                                  AND ObjectLink_Bank_To.DescId = zc_ObjectLink_BankAccount_Bank()
              LEFT JOIN Object AS Object_Bank_to ON Object_Bank_to.Id = ObjectLink_Bank_To.ChildObjectId

         WHERE Object_MemberMinus.DescId = zc_Object_MemberMinus()
           AND (Object_MemberMinus.isErased = FALSE OR inisErased = TRUE);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.21         *
 20.11.20         *
 07.10.20         *
 04.09.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberMinus (FALSE, FALSE, zfCalc_UserAdmin())
