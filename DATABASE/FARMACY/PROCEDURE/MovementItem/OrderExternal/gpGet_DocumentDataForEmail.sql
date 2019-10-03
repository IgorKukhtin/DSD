-- Function: gpGet_Object_City()

DROP FUNCTION IF EXISTS gpGet_DocumentDataForEmail(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_DocumentDataForEmail(
    IN inId          Integer,       -- ���� ������� <������>
    IN inSession     TVarChar       -- ������ ������������
)

RETURNS TABLE (Subject TVarChar, Body TBlob, AddressFrom TVarChar, AddressTo TVarChar
             , Host TVarChar, Port Integer, UserName TVarChar, Password TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbMail TVarChar;
  DECLARE vbUserMail TVarChar;
  DECLARE vbSubject TVarChar;
  DECLARE vbUserMailSign TBlob;
  DECLARE vbUnitSign TBlob;
  DECLARE vbJuridicalId_unit Integer;
  DECLARE vbJuridicalName TVarChar;
  DECLARE vbContractId Integer;
  DECLARE vbContractName TVarChar;
  DECLARE vbZakazName TVarChar;
  DECLARE vbFromId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);


   -- ���
   SELECT tmp.Mail, tmp.JuridicalId_unit, tmp.JuridicalName, tmp.ContractId, tmp.FromId
          INTO vbMail, vbJuridicalId_unit, vbJuridicalName, vbContractId, vbFromId
   FROM (WITH -- �������� ������ ������� (�.�. ����������)
              tmpMovement AS (SELECT MLO_From.ObjectId AS FromId, MLO_To.ObjectId AS ToId, MLO_Contract.ObjectId AS ContractId
                                   , ObjectLink_Juridical_Retail.ChildObjectId    AS RetailId
                                   , ObjectLink_Unit_Juridical.ChildObjectId      AS JuridicalId_unit
                                   , ObjectLink_Unit_Area.ChildObjectId           AS AreaId
                              FROM MovementLinkObject AS MLO_From
                                   LEFT JOIN MovementLinkObject AS MLO_Contract
                                                                ON MLO_Contract.MovementId = MLO_From.MovementId
                                                               AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                   -- !!!������ ��� - ������������ <�������� ����>!!!
                                   LEFT JOIN MovementLinkObject AS MLO_To
                                                                ON MLO_To.MovementId = MLO_From.MovementId
                                                               AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                                        ON ObjectLink_Unit_Area.ObjectId = MLO_To.ObjectId
                                                       AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                        ON ObjectLink_Unit_Juridical.ObjectId = MLO_To.ObjectId
                                                       AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
                                   LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                        ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                       AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                              WHERE MLO_From.MovementId = inId
                                AND MLO_From.DescId     = zc_MovementLinkObject_From()
                             )
            , tmpContactPerson AS (SELECT * FROM Object_ContactPerson_View)
         -- ���������
         SELECT tmpMovement.JuridicalId_unit
              , tmpMovement.FromId
              , COALESCE (View_ContactPerson_Contract_0.Mail, View_ContactPerson_Contract_1.Mail, View_ContactPerson_Contract_2.Mail, View_ContactPerson_Contract_3.Mail
                        , View_ContactPerson_0.Mail,          View_ContactPerson_1.Mail,          View_ContactPerson_2.Mail,          View_ContactPerson_3.Mail
                         ) AS Mail
              , COALESCE (View_ContactPerson_Contract_0.JuridicalName, View_ContactPerson_Contract_1.JuridicalName, View_ContactPerson_Contract_2.JuridicalName, View_ContactPerson_Contract_3.JuridicalName
                        , View_ContactPerson_0.JuridicalName,          View_ContactPerson_1.JuridicalName,          View_ContactPerson_2.JuridicalName,          View_ContactPerson_3.JuridicalName
                         ) AS JuridicalName
              , COALESCE (View_ContactPerson_Contract_0.ContractId, View_ContactPerson_Contract_1.ContractId, View_ContactPerson_Contract_2.ContractId, View_ContactPerson_Contract_3.ContractId
                        , 0
                         ) AS ContractId
         FROM tmpMovement
              -- ������� ���� �� ���������
              LEFT JOIN tmpContactPerson AS View_ContactPerson_Contract_0
                                                  ON View_ContactPerson_Contract_0.ContractId          = tmpMovement.ContractId
                                                 AND View_ContactPerson_Contract_0.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- ���� �� ������� ��� ���������� �� zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_Contract_0.RetailId            = tmpMovement.RetailId
                                                 AND View_ContactPerson_Contract_0.AreaId              = tmpMovement.AreaId
              LEFT JOIN tmpContactPerson AS View_ContactPerson_Contract_1
                                                  ON View_ContactPerson_Contract_1.ContractId          = tmpMovement.ContractId
                                                 AND View_ContactPerson_Contract_1.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- ���� �� ������� ��� ���������� �� zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_Contract_1.RetailId            = tmpMovement.RetailId
                                                 AND View_ContactPerson_Contract_1.AreaId              = zc_Area_Basis()
                                                 AND View_ContactPerson_Contract_0.JuridicalId IS NULL
              LEFT JOIN tmpContactPerson AS View_ContactPerson_Contract_2
                                                  ON View_ContactPerson_Contract_2.ContractId          = tmpMovement.ContractId
                                                 AND View_ContactPerson_Contract_2.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- ���� �� ������� ��� ���������� �� zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_Contract_2.RetailId            IS NULL
                                                 AND View_ContactPerson_Contract_2.AreaId              = tmpMovement.AreaId
                                                 AND View_ContactPerson_Contract_0.JuridicalId IS NULL
                                                 AND View_ContactPerson_Contract_1.JuridicalId IS NULL
              LEFT JOIN tmpContactPerson AS View_ContactPerson_Contract_3
                                                  ON View_ContactPerson_Contract_3.ContractId          = tmpMovement.ContractId
                                                 AND View_ContactPerson_Contract_3.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- ���� �� ������� ��� ���������� �� zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_Contract_3.RetailId            IS NULL
                                                 AND View_ContactPerson_Contract_3.AreaId              = zc_Area_Basis()
                                                 AND View_ContactPerson_Contract_0.JuridicalId IS NULL
                                                 AND View_ContactPerson_Contract_1.JuridicalId IS NULL
                                                 AND View_ContactPerson_Contract_2.JuridicalId IS NULL

              -- ����� ���� �� ��.�����
              LEFT JOIN tmpContactPerson AS View_ContactPerson_0
                                                  ON View_ContactPerson_0.JuridicalId         = tmpMovement.FromId
                                                 AND View_ContactPerson_0.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- ���� �� ������� ��� ���������� �� zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_0.RetailId            = tmpMovement.RetailId
                                                 AND View_ContactPerson_0.AreaId              = tmpMovement.AreaId
              LEFT JOIN tmpContactPerson AS View_ContactPerson_1
                                                  ON View_ContactPerson_1.JuridicalId         = tmpMovement.FromId
                                                 AND View_ContactPerson_1.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- ���� �� ������� ��� ���������� �� zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_1.RetailId            = tmpMovement.RetailId
                                                 AND View_ContactPerson_1.AreaId              = zc_Area_Basis()
                                                 AND View_ContactPerson_0.JuridicalId IS NULL
              LEFT JOIN tmpContactPerson AS View_ContactPerson_2
                                                  ON View_ContactPerson_2.JuridicalId         = tmpMovement.FromId
                                                 AND View_ContactPerson_2.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- ���� �� ������� ��� ���������� �� zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_2.RetailId            IS NULL
                                                 AND View_ContactPerson_2.AreaId              = tmpMovement.AreaId
                                                 AND View_ContactPerson_0.JuridicalId IS NULL
                                                 AND View_ContactPerson_1.JuridicalId IS NULL
              LEFT JOIN tmpContactPerson AS View_ContactPerson_3
                                                  ON View_ContactPerson_3.JuridicalId         = tmpMovement.FromId
                                                 AND View_ContactPerson_3.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- ���� �� ������� ��� ���������� �� zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_3.RetailId            IS NULL
                                                 AND View_ContactPerson_3.AreaId              = zc_Area_Basis()
                                                 AND View_ContactPerson_0.JuridicalId IS NULL
                                                 AND View_ContactPerson_1.JuridicalId IS NULL
                                                 AND View_ContactPerson_2.JuridicalId IS NULL
        ) AS tmp;


   -- ���
   vbContractName:= COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = vbContractId), '');
   
   
   -- ���
   SELECT Object_Unit_view.JuridicalName
       || ' �� ' || Object_Unit_view.Name AS ZakazName
        , SomeText                        AS UnitSign
        , MovementLinkObject.ObjectId     AS UnitId
          INTO vbZakazName
             , vbUnitSign
             , vbUnitId
   FROM MovementLinkObject
        LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = ObjectId
                                              AND Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_UnitEmailSign()
        LEFT JOIN Object_Unit_view ON Object_Unit_view.id = MovementLinkObject.ObjectId

   WHERE MovementLinkObject.DescId = zc_MovementLinkObject_To()
     AND MovementId = inId;

   -- ���
   SELECT Movement.InvNumber, Object_ImportExportLink_View.StringKey
          INTO vbInvNumber, vbSubject
   FROM MovementLinkObject
        LEFT JOIN Movement ON Movement.Id = MovementLinkObject.MovementId
        LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = vbUnitId
                                              AND Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_ClientEmailSubject()
                                              AND Object_ImportExportLink_View.ValueId = ObjectId
   WHERE MovementLinkObject.DescId = zc_MovementLinkObject_Contract()
     AND MovementLinkObject.MovementId = inId;


    -- ��������
    IF COALESCE (vbMail, '') = '' THEN
       RAISE EXCEPTION '� ������������ ���� ��� ������������� ��� � e-mail';
    END IF;

    IF vbUnitId in (4135547, 5120968, 3457773, 6741875, 377610, 377613, 494882, 6128298) AND vbFromId = 59610 --AND inSession = '3'
    THEN
      vbMail := 'orders_processing@badm.biz';
    END IF;

    -- ���
    SELECT ObjectString.valuedata, ObjectBlob_EMailSign.ValueData
           INTO vbUserMail, vbUserMailSign
    FROM ObjectLink AS User_Link_Member
         LEFT JOIN ObjectString ON ObjectString.descid = zc_ObjectString_Member_EMail()
                               AND ObjectString.ObjectId = User_Link_Member.ChildObjectId
         LEFT JOIN ObjectBlob AS ObjectBlob_EMailSign
                              ON ObjectBlob_EMailSign.ObjectId = User_Link_Member.ChildObjectId
                             AND ObjectBlob_EMailSign.DescId =  zc_ObjectBlob_Member_EMailSign()
    WHERE User_Link_Member.ObjectId = vbUserId AND User_Link_Member.DescId = zc_objectlink_user_member();


    -- ���
    IF COALESCE(vbUserMail, '') = '' THEN
       vbUserMail := '';
    ELSE
       vbUserMail := ', '|| CASE WHEN LOWER (TRIM (vbUserMail)) = LOWER ('kukhtinigor@gmail.com') THEN 'ashtu777@gmail.com' ELSE vbUserMail END;
    END IF;

    -- ���
    IF COALESCE(vbSubject, '') = '' THEN
       vbSubject := ('����� ' || vbContractName || ' ' || vbJuridicalName || ' �� - ' || COALESCE (vbZakazName, '')) :: TVarChar;

    ELSEIF vbContractName <> '' THEN
       vbSubject := vbContractName || ' ' || vbSubject;

    END IF;


    -- ���
    vbMail := (vbMail || vbUserMail) :: TVarChar;


    -- ���������
    RETURN QUERY
       WITH tmpComment AS (SELECT MS_Comment.ValueData AS Comment FROM MovementString AS MS_Comment WHERE MS_Comment.MovementId = inId AND MS_Comment.DescId = zc_MovementString_Comment())
          , tmpEmail_all AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= inSession) AS tmp WHERE tmp.EmailKindId = zc_Enum_EmailKind_OutOrder())
          , tmpEmail_jur AS (SELECT * FROM tmpEmail_all WHERE JuridicalId = vbJuridicalId_unit)
          , tmpEmail AS (SELECT * FROM tmpEmail_jur UNION ALL SELECT * FROM tmpEmail_all WHERE COALESCE (JuridicalId, 0) = 0 AND NOT EXISTS (SELECT 1 FROM tmpEmail_jur))
       SELECT
         -- ����
         REPLACE (vbSubject, '#1#', '#' || vbInvNumber || '#') :: TVarChar AS Subject

         -- Body
       , (CASE WHEN (SELECT Comment FROM tmpComment) <> ''
                    THEN '���������� ����� : ' || (SELECT Comment FROM tmpComment) || CHR (13) || CHR (13) || CHR (13) || CHR (13) || CHR (13)
               ELSE ''
         END
      || COALESCE (vbUnitSign, '') || '<br>' || COALESCE (vbUserMailSign, '')) :: TBlob AS Body

         -- Body
       , gpGet_Mail.Value            AS AddressFrom   --*** zc_Mail_From() --'zakaz_family-neboley@mail.ru'::TVarChar,
       , vbMail                      AS AddressTo
       , gpGet_Host.Value            AS Host          --*** zc_Mail_Host(), --'smtp.mail.ru'::TVarChar,
       , gpGet_Port.Value :: Integer AS Port          --*** zc_Mail_Port(), --465,
       , gpGet_User.Value            AS UserName      --*** zc_Mail_User(), --'zakaz_family-neboley@mail.ru'::TVarChar,
       , gpGet_Password.Value        AS Password      --*** zc_Mail_Password() --'fgntrfyt,jktq'::TVarChar;

       FROM tmpEmail AS gpGet_Host
            LEFT JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
            LEFT JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
            LEFT JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
            LEFT JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
     WHERE gpGet_Host.EmailToolsId = zc_Enum_EmailTools_Host()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.03.16                                        *
 14.01.15                         *
 24.12.14                         *
 18.11.14                         *
*/

-- ����
-- SELECT * FROM gpGet_DocumentDataForEmail (inId:= 8141142, inSession:= '377790');
