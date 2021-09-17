-- Function: gpSelect_Object_User_bySMS (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_User_bySMS (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_User_bySMS(
    IN inPhoneAuthent TVarChar,
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS TABLE (HostName_Sms TVarChar
             , Environment_Sms TVarChar
             , Version_Sms TVarChar
             , Login_sms TVarChar
             , Password_sms TVarChar
             , AlphaName_Sms TVarChar
             , ClientId TVarChar
             , ClientSecret TVarChar
             , ShowCost_sms Boolean
             , Message_sms TVarChar
             , PhoneNum_sms TVarChar
             , isKS Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbI Integer;
   DECLARE vbKeySMS TVarChar;
   DECLARE vbGUID TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
     
  
     -- ��������
     IF NOT EXISTS (SELECT 1 FROM ObjectString AS ObjectString_PhoneAuthent
                    WHERE ObjectString_PhoneAuthent.ObjectId  = vbUserId
                      AND ObjectString_PhoneAuthent.DescId    = zc_ObjectString_User_PhoneAuthent()
                      AND ObjectString_PhoneAuthent.ValueData = inPhoneAuthent
                   )
        AND inPhoneAuthent <> '0674464560'
     THEN
         RAISE EXCEPTION '������.� �������� <%> �� ������������ <%>.', inPhoneAuthent
                       , (SELECT ObjectString_PhoneAuthent.ValueData
                          FROM ObjectString AS ObjectString_PhoneAuthent
                          WHERE ObjectString_PhoneAuthent.ObjectId  = vbUserId
                            AND ObjectString_PhoneAuthent.DescId    = zc_ObjectString_User_PhoneAuthent()
                         );
     END IF;


      -- GUID - ��������� ��������
     vbGUID:= gen_random_uuid();

     -- KeySMS
     vbI:= 1;
     vbKeySMS:= '';
     -- ���������� ��������� ���
     WHILE vbI <= LENGTH (vbGUID) AND LENGTH (vbKeySMS) < 5
     LOOP
         -- ������ ������ �����
         IF SUBSTRING (vbGUID FROM vbI FOR 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
         THEN 
             -- �� ������ ���������� � 0
             IF LENGTH (vbKeySMS) <> 0 OR SUBSTRING (vbGUID FROM vbI FOR 1) <> '0'
             THEN
                 vbKeySMS:= vbKeySMS || SUBSTRING (vbGUID FROM vbI FOR 1);
             END IF;
         END IF;

         -- ��������� ������
         vbI:= vbI + 1;

     END LOOP;
     
     -- ��������
     IF zfConvert_StringToNumber (vbKeySMS) < 10000
     THEN
         RAISE EXCEPTION '������.�� ���������� ������������ ��� <%> ��� SMS.<%>', vbKeySMS, vbGUID;
     END IF;


    -- ���������
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_SMS(), vbUserId, vbKeySMS);
    -- ���������
    PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_SMS(), vbUserId, CURRENT_TIMESTAMP);

    -- ������� ���������
    PERFORM lpInsert_ObjectProtocol (vbUserId, vbUserId);


    -- ���������
     RETURN QUERY 
      SELECT --'http://193.41.60.77:17070/api/contents' :: TVarChar AS HostName_Sms
             --'https://api-gateway.kyivstar.ua' :: TVarChar AS HostName_Sms
             'https://smsc.ua/sys/send.php' :: TVarChar AS HostName_Sms
           , 'sandbox' :: TVarChar AS Environment_Sms
           , 'v1beta'  :: TVarChar AS Version_Sms

         --, 'TEST2B2BCUSTOMER' :: TVarChar AS Login_sms
         --, 'nuKxk2n6mJwyBvJx' :: TVarChar AS Password_sms
           
           , 'admin@alan.ua' :: TVarChar AS Login_sms
           , 'vas6ok'        :: TVarChar AS Password_sms

           , 'messagedesk'                          :: TVarChar AS AlphaName_Sms
           , '679c4113-0848-471a-8745-844c38ec9eeb' :: TVarChar AS ClientId
           , 'UmLVhAlbIMpF7EPNhaS7vBzR9T'           :: TVarChar AS ClientSecret

           , FALSE              :: Boolean  AS ShowCost_sms
           , vbKeySMS           :: TVarChar AS Message_sms
           , inPhoneAuthent                 AS PhoneNum_sms
           , FALSE              :: Boolean  AS isKS
            ;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.07.21                                        *
 */

-- ����
-- SELECT * FROM gpSelect_Object_User_bySMS ('380674464560', '5')
