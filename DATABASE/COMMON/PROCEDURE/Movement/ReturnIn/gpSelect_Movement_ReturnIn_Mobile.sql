-- Function: gpSelect_Movement_ReturnIn_Mobile()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnIn_Mobile (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReturnIn_Mobile(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsPartnerDate      Boolean ,
    IN inIsErased           Boolean ,
    IN inJuridicalBasisId   Integer   ,
    IN inMemberId           Integer   , -- торговый агент
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , ParentId Integer, InvNumber_Parent TVarChar
             , StatusCode Integer, StatusName TVarChar
             , Checked Boolean
             , isPartner Boolean
             , PriceWithVAT Boolean
             , OperDatePartner TDateTime, InvNumberPartner TVarChar, InvNumberMark TVarChar
             , VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalCountPartner TFloat, TotalCountTare TFloat
             , TotalCountSh TFloat, TotalCountKg TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat
             , TotalSummChange TFloat, TotalSumm TFloat
             , CurrencyValue TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , CurrencyDocumentName TVarChar, CurrencyPartnerName TVarChar
             , JuridicalName_From TVarChar, OKPO_From TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , MemberId Integer, MemberName TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
             , Comment TVarChar
             , isError Boolean
             , isEDI Boolean
             , isList Boolean
             , isPromo Boolean
             , MovementPromo TVarChar

             , InsertName TVarChar
             , InsertDate TDateTime
             , InsertMobileDate TDateTime
             , MemberInsertName TVarChar
             , UnitCode Integer
             , UnitName TVarChar
             , PositionName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsXleb Boolean;
   DECLARE vbIsProjectMobile Boolean;
   DECLARE vbUserId_Member   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);


     -- Только так определяется что пользователь inSession - Торговый агент - т.е. у него есть моб телефон, может потом для этого заведем спец роль и захардкодим
     vbIsProjectMobile:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = vbUserId AND ObjectBoolean.DescId = zc_ObjectBoolean_User_ProjectMobile());

     IF inMemberId > 0
     THEN
         -- Определяется для <Физическое лицо> - его UserId
         vbUserId_Member:= (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Member() AND OL.ChildObjectId = inMemberId);
         -- Проверка
         IF COALESCE (vbUserId_Member, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Для ФИО <%> не определно значение <Пользователь>.', lfGet_Object_ValueData (inMemberId);
         END IF;

     ELSEIF vbIsProjectMobile = TRUE
     THEN
         -- в этом случае - видит только себя
         vbUserId_Member:= vbUserId;
         -- !!!меняем значение!!! - Определяется для UserId - его <Физическое лицо>
         inMemberId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Member() AND OL.ObjectId = vbUserId);
     ELSE
         -- в этом случае - видит ВСЕ
         vbUserId_Member:= 0;
         -- !!!меняем значение!!!
         inMemberId:= 0;
     END IF;


     -- Проверка - Торговый агент видит только себя
     IF vbIsProjectMobile = TRUE AND vbUserId_Member <> vbUserId
     THEN
         RAISE EXCEPTION 'Ошибка.Не достаточно прав доступа.';
     END IF;



     -- !!!Хлеб!!!
     vbIsXleb:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 131936  AND UserId = vbUserId);

     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                         UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentDnepr() AS AccessKeyId WHERE vbIsXleb = TRUE
                              )

        , tmpMovement AS (SELECT tmp.*, MovementLinkObject_Insert.ObjectId AS UserId_insert
                          FROM (SELECT Movement.id
                                FROM tmpStatus
                                     JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                  AND Movement.DescId = zc_Movement_ReturnIn() 
                                                  AND Movement.StatusId = tmpStatus.StatusId
                                     JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
                                WHERE inIsPartnerDate = FALSE
                               UNION ALL
                                SELECT MovementDate_OperDatePartner.MovementId  AS Id
                                FROM MovementDate AS MovementDate_OperDatePartner
                                     JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId AND Movement.DescId = zc_Movement_ReturnIn()
                                     JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                                     JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
                                WHERE inIsPartnerDate = TRUE
                                  AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                ) AS tmp
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                              ON MovementLinkObject_Insert.MovementId = tmp.Id
                                                             AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
                                                             AND MovementLinkObject_Insert.ObjectId > 0
                          WHERE MovementLinkObject_Insert.ObjectId = vbUserId_Member
                             OR vbUserId_Member = 0
                          )

         , tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.BranchId
                           FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Movement.ParentId                          AS ParentId
           , (Movement_Parent.InvNumber || ' от ' || Movement_Parent.OperDate :: Date :: TVarChar ) :: TVarChar AS InvNumber_Parent
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData,   FALSE) :: Boolean AS Checked
           , COALESCE (MovementBoolean_isPartner.ValueData, FALSE) :: Boolean AS isPartner
           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , MovementString_InvNumberMark.ValueData     AS InvNumberMark
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_ChangePercent.ValueData      AS ChangePercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalCountPartner.ValueData  AS TotalCountPartner
           , MovementFloat_TotalCountTare.ValueData     AS TotalCountTare
           , MovementFloat_TotalCountSh.ValueData       AS TotalCountSh
           , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementFloat_TotalSummChange.ValueData    AS TotalSummChange
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , CAST (COALESCE (MovementFloat_CurrencyValue.ValueData, 0) AS TFloat)  AS CurrencyValue
           , Object_From.Id                             AS FromId
           , Object_From.ValueData                      AS FromName
           , Object_To.Id                               AS ToId
           , Object_To.ValueData                        AS ToName
           , Object_PaidKind.Id                         AS PaidKindId
           , Object_PaidKind.ValueData                  AS PaidKindName
           , View_Contract_InvNumber.ContractId         AS ContractId
           , View_Contract_InvNumber.ContractCode       AS ContractCode
           , View_Contract_InvNumber.InvNumber          AS ContractName
           , View_Contract_InvNumber.ContractTagName    AS ContractTagName
           , Object_CurrencyDocument.ValueData          AS CurrencyDocumentName
           , Object_CurrencyPartner.ValueData           AS CurrencyPartnerName
           , Object_JuridicalFrom.ValueData             AS JuridicalName_From
           , ObjectHistory_JuridicalDetails_View.OKPO   AS OKPO_From
           , View_InfoMoney.InfoMoneyGroupName          AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName    AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode               AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName               AS InfoMoneyName
           , Object_PriceList.id                        AS PriceListId
           , Object_PriceList.valuedata                 AS PriceListName
           , Object_TaxKind.Id                	        AS DocumentTaxKindId
           , Object_TaxKind.ValueData        	        AS DocumentTaxKindName
           , Object_Member.Id                           AS MemberId
           , Object_Member.ValueData                    AS MemberName
           , Object_ReestrKind.Id             	        AS ReestrKindId
           , Object_ReestrKind.ValueData       	        AS ReestrKindName
           , MovementString_Comment.ValueData           AS Comment
           , MovementBoolean_Error.ValueData            AS isError
           , COALESCE (MovementLinkMovement_MasterEDI.MovementChildId, 0) <> 0 AS isEDI

           , COALESCE (MovementBoolean_List.ValueData, FALSE) :: Boolean AS isList

           , COALESCE(MovementBoolean_Promo.ValueData, FALSE) AS isPromo
           , zfCalc_PromoMovementName (NULL, Movement_Promo.InvNumber :: TVarChar, Movement_Promo.OperDate, MD_StartSale.ValueData, MD_EndReturn.ValueData) AS MovementPromo

           , Object_User.ValueData                  AS InsertName
           , MovementDate_Insert.ValueData          AS InsertDate
           , MovementDate_InsertMobile.ValueData    AS InsertMobileDate
           , Object_MemberInsert.ValueData          AS MemberInsertName
           , Object_Unit.ObjectCode                 AS UnitCode
           , Object_Unit.ValueData                  AS UnitName
           , Object_Position.ValueData              AS PositionName

       FROM tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.id = Movement.ParentId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Object AS Object_User ON Object_User.Id = tmpMovement.UserId_insert

            LEFT JOIN MovementBoolean AS MovementBoolean_Error
                                      ON MovementBoolean_Error.MovementId =  Movement.Id
                                     AND MovementBoolean_Error.DescId = zc_MovementBoolean_Error()
            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_isPartner
                                      ON MovementBoolean_isPartner.MovementId =  Movement.Id
                                     AND MovementBoolean_isPartner.DescId = zc_MovementBoolean_isPartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                      ON MovementBoolean_Promo.MovementId =  Movement.Id
                                     AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

            LEFT JOIN MovementBoolean AS MovementBoolean_List
                                      ON MovementBoolean_List.MovementId = Movement.Id
                                     AND MovementBoolean_List.DescId = zc_MovementBoolean_List()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_InsertMobile
                                   ON MovementDate_InsertMobile.MovementId = Movement.Id
                                  AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  Movement.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                    ON MovementFloat_TotalSummChange.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummChange.DescId = zc_MovementFloat_TotalSummChange()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalFrom.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

--add Tax
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_MasterEDI
                                           ON MovementLinkMovement_MasterEDI.MovementId = Movement.Id 
                                          AND MovementLinkMovement_MasterEDI.DescId = zc_MovementLinkMovement_MasterEDI()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Promo
                                           ON MovementLinkMovement_Promo.MovementId = Movement.Id
                                          AND MovementLinkMovement_Promo.DescId = zc_MovementLinkMovement_Promo()
            LEFT JOIN Movement AS Movement_Promo ON Movement_Promo.Id = MovementLinkMovement_Promo.MovementChildId
            LEFT JOIN MovementDate AS MD_StartSale
                                   ON MD_StartSale.MovementId =  Movement_Promo.Id
                                  AND MD_StartSale.DescId = zc_MovementDate_StartSale()
            LEFT JOIN MovementDate AS MD_EndReturn
                                   ON MD_EndReturn.MovementId =  Movement_Promo.Id
                                  AND MD_EndReturn.DescId = zc_MovementDate_EndReturn()

            --
            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_MemberInsert ON Object_MemberInsert.Id = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId

     WHERE vbIsXleb = FALSE OR (View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_30103() -- Хлеб
                                AND vbIsXleb = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_ReturnIn_Mobile (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.04.17         *
*/
-- тест
-- SELECT * FROM gpSelect_Movement_ReturnIn_Mobile (inStartDate:= '01.12.2015', inEndDate:= '01.12.2015', inIsPartnerDate:=FALSE, inIsErased :=TRUE, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
