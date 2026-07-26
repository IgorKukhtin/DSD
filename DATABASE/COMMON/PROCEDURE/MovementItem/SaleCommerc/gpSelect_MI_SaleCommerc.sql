	-- Function: gpSelect_MI_SaleCommerc()

DROP FUNCTION IF EXISTS gpSelect_MI_SaleCommerc (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_SaleCommerc(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , JuridicalName TVarChar, RetailName TVarChar, SectionName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SaleCommerc());
     vbUserId:= lpGetUserBySession (inSession);

 
    --
     RETURN QUERY
        SELECT
             MovementItem.Id                      AS Id
           , Object_Contract.Id                   AS ContractId
           , Object_Contract.ObjectCode           AS ContractCode
           , Object_Contract.ValueData            AS ContractName

           , Object_Branch.Id                     AS BranchId
           , Object_Branch.ObjectCode             AS BranchCode
           , Object_Branch.ValueData              AS BranchName

           , Object_Partner.Id                    AS PartnerId
           , Object_Partner.ObjectCode            AS PartnerCode
           , Object_Partner.ValueData             AS PartnerName
           
           , Object_Juridical.ValueData           AS JuridicalName
           , Object_Retail.ValueData              AS RetailName
           , Object_Section.ValueData             AS SectionName

           , Object_PaidKind.Id                   AS PaidKindId
           , Object_PaidKind.ValueData            AS PaidKindName

           , MovementItem.isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                             ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MILinkObject_Partner.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                             ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            --
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId      = Object_Partner.Id
                                AND ObjectLink_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Section
                                 ON ObjectLink_Juridical_Section.ObjectId = Object_Juridical.Id
                                AND ObjectLink_Juridical_Section.DescId = zc_ObjectLink_Juridical_Section()
            LEFT JOIN Object AS Object_Section ON Object_Section.Id = ObjectLink_Juridical_Section.ChildObjectId
          ; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 22.07.26         * 
*/

-- тест
-- SELECT * FROM gpSelect_MI_SaleCommerc (34853167, FALSE, zfCalc_UserAdmin());
