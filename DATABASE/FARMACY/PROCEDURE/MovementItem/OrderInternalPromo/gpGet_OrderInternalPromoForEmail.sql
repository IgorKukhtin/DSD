-- Function: gpGet_OrderInternalPromoForEmail()

DROP FUNCTION IF EXISTS gpGet_OrderInternalPromoForEmail(integer, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OrderInternalPromoForEmail(
    IN inMovementId  Integer,       -- ���� ������� <������>
    IN inJuridicalId Integer      , -- ���������
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
  DECLARE vbSubject TVarChar;
  DECLARE vbZakazName TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);


   -- ���
   SELECT Movement.InvNumber
   INTO vbInvNumber
   FROM Movement
   WHERE Movement.ID = inMovementId;
   
   vbMail := CASE WHEN inJuridicalId = 59611  THEN 'vmileeva@optimapharm.ua,lbryukhovets@optimapharm.ua '
                  WHEN inJuridicalId = 59610 THEN 'centr2_cc@badm.biz'
                  WHEN inJuridicalId = 59612 THEN 'volitskayairina@ventaltd.com.ua'
                  WHEN inJuridicalId = 183353 THEN 'n.ivanova@fitolek.com'
                  WHEN inJuridicalId = 410822 THEN 's.boiko@ametrin.com.ua'
                  ELSE '' END;          
   
    -- ��������
    IF COALESCE (vbMail, '') = '' THEN
       RAISE EXCEPTION '� ������������ ���� ��� ������������� ��� � e-mail';
    END IF;


    vbSubject := '����� #1#';

    -- ���
    vbMail := (vbMail || ',artur17111@gmail.com') :: TVarChar;

    -- �������� ��� �����
    IF vbUserId = 3
    THEN
      vbMail := 'olegsh1264@gmail.com';
    END IF;
    
    -- ���������
    RETURN QUERY
       WITH tmpComment AS (SELECT MS_Comment.ValueData AS Comment FROM MovementString AS MS_Comment WHERE MS_Comment.MovementId = inMovementId AND MS_Comment.DescId = zc_MovementString_Comment())
          , tmpEmail AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= inSession) AS tmp WHERE tmp.EmailKindId = zc_Enum_EmailKind_OutOrder())
       SELECT
         -- ����
         REPLACE (vbSubject, '#1#', '#' || vbInvNumber || '#') :: TVarChar AS Subject

         -- Body
       , ' ' :: TBlob AS Body

         -- Body
       , zc_Mail_From()              AS AddressFrom   
       , vbMail                      AS AddressTo
       
       , zc_Mail_Host():: TVarChar AS Host
       , zc_Mail_Port():: Integer AS Port
       , zc_Mail_User():: TVarChar AS UserName
       , zc_Mail_Password():: TVarChar AS Password
       
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.08.21                                                       *
*/

-- ����
-- 
SELECT * FROM gpGet_OrderInternalPromoForEmail (inMovementId := 23631157 , inJuridicalId := 410822 , inSession:= '298786');