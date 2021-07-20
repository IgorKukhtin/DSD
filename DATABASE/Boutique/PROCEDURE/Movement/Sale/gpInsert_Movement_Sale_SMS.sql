-- Function: gpInsert_Movement_Sale_SMS()


DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_SMS (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Sale_SMS(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
   OUT outSmsSettingsName     TVarChar   , -- 
   OUT outLogin               TVarChar   , -- 
   OUT outPassword            TVarChar   , -- 
   OUT outMessage             TVarChar   , -- 
   OUT outPhoneSMS            TVarChar   , -- 
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbI Integer;
   DECLARE vbKeySMS TVarChar;
   DECLARE vbGUID TVarChar;
   DECLARE vbDiscountTax TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId := lpGetUserBySession (inSession);


     -- ����� � ��������
     SELECT ObjectString_PhoneMobile.ValueData AS PhoneMobile
          , ObjectFloat_DiscountTax.ValueData  AS DiscountTax
            INTO outPhoneSMS, vbDiscountTax
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectString AS ObjectString_PhoneMobile
                                 ON ObjectString_PhoneMobile.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectString_PhoneMobile.DescId = zc_ObjectString_Client_PhoneMobile()
          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                ON ObjectFloat_DiscountTax.ObjectId = MovementLinkObject_To.ObjectId
                               AND ObjectFloat_DiscountTax.DescId   = zc_ObjectFloat_Client_DiscountTax()
     WHERE Movement.Id = ioId;
     
     
     -- ��������
     IF NOT EXISTS (SELECT 1
                    FROM MovementItem
                         JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                     ON MILinkObject_DiscountSaleKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()
                                                    AND MILinkObject_DiscountSaleKind.ObjectId       = zc_Enum_DiscountSaleKind_Client()
                    WHERE MovementItem.MovementId = ioId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     > 0
                   )
        AND vbDiscountTax > 0
     THEN
         RAISE EXCEPTION '������.��� ������ <%> ��� ������� �������� SMS.', lfGet_Object_ValueData_sh (zc_Enum_DiscountSaleKind_Period());
     END IF;

     -- ��������
     IF COALESCE (TRIM (outPhoneSMS), '') = ''
     THEN
         RAISE EXCEPTION '������.� ���������� <%> �� ���������� ����� �������� ��� �������� SMS.'
                        , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_To()))
                         ;
     END IF;
     -- ��������
     IF COALESCE (vbDiscountTax, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� ������ <% %> ��� ������� �������� SMS.', zfConvert_FloatToString (vbDiscountTax), '%';
     END IF;

     -- ��������
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = ioId AND MB.ValueData = TRUE AND MB.DescId = zc_MovementBoolean_DisableSMS())
     THEN
         RAISE EXCEPTION '������.��������� ������������� ���������� �� SMS.';
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
     
     
       
     -- � �������� ��� SMS
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PhoneSMS(), ioId, outPhoneSMS);
     
     -- ������ ��� SMS 
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_KeySMS(), ioId, vbKeySMS :: TFloat);
     
     -- ������ �������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTaxSMS(), ioId, vbDiscountTax);
     
     


     -- ���������
     SELECT tmp.Name     :: TVarChar
          , tmp.Login    :: TVarChar
          , tmp.Password :: TVarChar
          , REPLACE (REPLACE (tmp.Message, '%1', vbKeySMS), '%2', zfConvert_FloatToString (vbDiscountTax))
--          , REPLACE (REPLACE (tmp.Message, '%1', vbKeySMS), '%2', zfConvert_FloatToString (50))
        --, outPhoneSMS
            -- !����� ��� �����!
          , '0674464560'
--          , '0965592230'
            INTO outSmsSettingsName, outLogin, outPassword, outMessage, outPhoneSMS
     FROM gpSelect_Object_SmsSettings (inIsShowAll := FALSE, inSession := inSession) AS tmp
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.06.21         *
 */

-- ����
-- SELECT * FROM gpInsert_Movement_Sale_SMS (ioId := 11404, inSession:= zfCalc_UserAdmin());
