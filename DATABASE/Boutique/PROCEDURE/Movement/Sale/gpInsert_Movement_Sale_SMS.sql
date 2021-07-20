-- Function: gpInsert_Movement_Sale_SMS()


DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_SMS (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Sale_SMS(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
   OUT outSmsSettingsName     TVarChar   , -- 
   OUT outLogin               TVarChar   , -- 
   OUT outPassword            TVarChar   , -- 
   OUT outMessage             TVarChar   , -- 
   OUT outPhoneSMS            TVarChar   , -- 
    IN inSession              TVarChar    -- сессия пользователя
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
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId := lpGetUserBySession (inSession);


     -- нашли № телефона
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
     
     
     -- Проверка
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
         RAISE EXCEPTION 'Ошибка.Для скидки <%> нет функции отправки SMS.', lfGet_Object_ValueData_sh (zc_Enum_DiscountSaleKind_Period());
     END IF;

     -- Проверка
     IF COALESCE (TRIM (outPhoneSMS), '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.У Покупателя <%> не установлен номер телефона для отправки SMS.'
                        , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_To()))
                         ;
     END IF;
     -- Проверка
     IF COALESCE (vbDiscountTax, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Для скидки <% %> нет функции отправки SMS.', zfConvert_FloatToString (vbDiscountTax), '%';
     END IF;

     -- Проверка
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = ioId AND MB.ValueData = TRUE AND MB.DescId = zc_MovementBoolean_DisableSMS())
     THEN
         RAISE EXCEPTION 'Ошибка.Отключена идентификация покупателя по SMS.';
     END IF;


     -- GUID - случайное значение
     vbGUID:= gen_random_uuid();

     -- KeySMS
     vbI:= 1;
     vbKeySMS:= '';
     -- Генерируем случайный код
     WHILE vbI <= LENGTH (vbGUID) AND LENGTH (vbKeySMS) < 5
     LOOP
         -- найдем только цифры
         IF SUBSTRING (vbGUID FROM vbI FOR 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
         THEN 
             -- не должен начинаться с 0
             IF LENGTH (vbKeySMS) <> 0 OR SUBSTRING (vbGUID FROM vbI FOR 1) <> '0'
             THEN
                 vbKeySMS:= vbKeySMS || SUBSTRING (vbGUID FROM vbI FOR 1);
             END IF;
         END IF;

         -- следующий символ
         vbI:= vbI + 1;

     END LOOP;
     
     -- Проверка
     IF zfConvert_StringToNumber (vbKeySMS) < 10000
     THEN
         RAISE EXCEPTION 'Ошибка.Не получилось сформировать код <%> для SMS.<%>', vbKeySMS, vbGUID;
     END IF;
     
     
       
     -- № телефона для SMS
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PhoneSMS(), ioId, outPhoneSMS);
     
     -- Пароль для SMS 
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_KeySMS(), ioId, vbKeySMS :: TFloat);
     
     -- Скидка клиента
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTaxSMS(), ioId, vbDiscountTax);
     
     


     -- Результат
     SELECT tmp.Name     :: TVarChar
          , tmp.Login    :: TVarChar
          , tmp.Password :: TVarChar
          , REPLACE (REPLACE (tmp.Message, '%1', vbKeySMS), '%2', zfConvert_FloatToString (vbDiscountTax))
--          , REPLACE (REPLACE (tmp.Message, '%1', vbKeySMS), '%2', zfConvert_FloatToString (50))
        --, outPhoneSMS
            -- !номер для теста!
          , '0674464560'
--          , '0965592230'
            INTO outSmsSettingsName, outLogin, outPassword, outMessage, outPhoneSMS
     FROM gpSelect_Object_SmsSettings (inIsShowAll := FALSE, inSession := inSession) AS tmp
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.21         *
 */

-- тест
-- SELECT * FROM gpInsert_Movement_Sale_SMS (ioId := 11404, inSession:= zfCalc_UserAdmin());
