--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MovementString_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BankAccount', 'Расчетный счет' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankAccount');

CREATE OR REPLACE FUNCTION zc_MovementString_BankMFO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankMFO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BankMFO', 'МФО' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankMFO');

CREATE OR REPLACE FUNCTION zc_MovementString_BankName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BankName', 'Название банка' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankName');

CREATE OR REPLACE FUNCTION zc_MovementString_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Comment', 'Примечание' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Comment');

CREATE OR REPLACE FUNCTION zc_MovementString_CommentMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CommentMain', 'Примечание (общее)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentMain');

CREATE OR REPLACE FUNCTION zc_MovementString_CommentError() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentError'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CommentError', 'Примечание (ошибка)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentError');

CREATE OR REPLACE FUNCTION zc_MovementString_CommentStop() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentStop'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CommentStop', 'Примечание причина  простоя' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentStop');


CREATE OR REPLACE FUNCTION zc_MovementString_Desc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Desc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Desc', 'Тип документа' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Desc');

CREATE OR REPLACE FUNCTION zc_MovementString_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_GLNCode', 'GLN код юр.лица' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_GLNCode');

CREATE OR REPLACE FUNCTION zc_MovementString_GLNPlaceCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_GLNPlaceCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_GLNPlaceCode', 'GLN код контрагента' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_GLNPlaceCode');

CREATE OR REPLACE FUNCTION zc_MovementString_FileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_FileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_FileName', 'Имя файла' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_FileName');

CREATE OR REPLACE FUNCTION zc_MovementString_DeclarFileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_DeclarFileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_DeclarFileName', 'Имя файла DECLAR' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_DeclarFileName');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberBranch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberBranch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberBranch', 'Номер филиала' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberBranch');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberMark', 'Номер перекресленої зеленої марки зi складу' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberMark');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberSaleLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberSaleLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberSaleLink', 'Номер накладной продажи контрагенту (привязка возврата)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberSaleLink');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberOrder', 'Номер заявки контрагента' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberOrder');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberRegistered() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberRegistered'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberRegistered', 'Номер квитанции' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberRegistered');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberPartner', 'Номер накладной у контрагента' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberPartner');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberTax', 'Номер налоговой накладной' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberTax');

CREATE OR REPLACE FUNCTION zc_MovementString_JuridicalName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_JuridicalName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_JuridicalName', 'JuridicalName' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_JuridicalName');

CREATE OR REPLACE FUNCTION zc_MovementString_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_OKPO', 'ОКПО' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_OKPO');

CREATE OR REPLACE FUNCTION zc_MovementString_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_PartionGoods', 'Партия товара' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_PartionGoods');

CREATE OR REPLACE FUNCTION zc_MovementString_CertificateNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CertificateNumber', 'Ветеринарне свідоцтво №' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateNumber');

CREATE OR REPLACE FUNCTION zc_MovementString_CertificateSeries() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateSeries'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CertificateSeries', 'Ветеринарне свідоцтво Серія' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateSeries');

CREATE OR REPLACE FUNCTION zc_MovementString_CertificateSeriesNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateSeriesNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CertificateSeriesNumber', 'Ветеринарне свідоцтво Серія №' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateSeriesNumber');

CREATE OR REPLACE FUNCTION zc_MovementString_ExpertPrior() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_ExpertPrior'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_ExpertPrior', 'Експертний висновок' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_ExpertPrior');

CREATE OR REPLACE FUNCTION zc_MovementString_ExpertLast() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_ExpertLast'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_ExpertLast', 'Експертний висновок (параметры)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_ExpertLast');

CREATE OR REPLACE FUNCTION zc_MovementString_QualityNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_QualityNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_QualityNumber', 'Декларація виробника №' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_QualityNumber');

CREATE OR REPLACE FUNCTION zc_MovementString_FromINN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_FromINN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_FromINN', 'ИНН от кого' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_FromINN');

CREATE OR REPLACE FUNCTION zc_MovementString_ToINN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_ToINN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_ToINN', 'ИНН кому' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_ToINN');

CREATE OR REPLACE FUNCTION zc_MovementString_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Contract', 'Договор' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Contract');

CREATE OR REPLACE FUNCTION zc_MovementString_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_MovementId', 'Список № документов' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_MovementId');

CREATE OR REPLACE FUNCTION zc_MovementString_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_GUID', 'Глобальный уникальный идентификатор' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_GUID');

CREATE OR REPLACE FUNCTION zc_MovementString_AddressByGPS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_AddressByGPS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_AddressByGPS', 'Адрес, определенный по GPS' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_AddressByGPS');

CREATE OR REPLACE FUNCTION zc_MovementString_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Retail', 'Торговая сеть в которой проходит акция' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Retail');

CREATE OR REPLACE FUNCTION zc_MovementString_CarComment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CarComment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CarComment', 'Примечание к отгрузке' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CarComment');

CREATE OR REPLACE FUNCTION zc_MovementString_IP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_IP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_IP', 'IP' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_IP');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberInvoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberInvoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberInvoice', 'Счет(клиента)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberInvoice');




  --!!!!!!!!!!!!!!!!!!!!!!!!!!Аптека
CREATE OR REPLACE FUNCTION zc_MovementString_Bayer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Bayer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Bayer', 'ФИО клиента для чека по VIP' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Bayer');

CREATE OR REPLACE FUNCTION zc_MovementString_FiscalCheckNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_FiscalCheckNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_FiscalCheckNumber', 'Номер фискального чека' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_FiscalCheckNumber');

CREATE OR REPLACE FUNCTION zc_MovementString_BayerPhone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BayerPhone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BayerPhone', 'Контактный телефон (Покупателя)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BayerPhone');

CREATE OR REPLACE FUNCTION zc_MovementString_MedicSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_MedicSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_MedicSP', 'ФИО врача (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_MedicSP');

CREATE OR REPLACE FUNCTION zc_MovementString_MemberSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_MemberSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_MemberSP', 'ФИО пациента (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_MemberSP');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberSP', 'Номер рецепта (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberSP');

CREATE OR REPLACE FUNCTION zc_MovementString_Ambulance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Ambulance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Ambulance', '№ амбулатории ' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Ambulance');

CREATE OR REPLACE FUNCTION zc_MovementString_AccountNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_AccountNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_AccountNumber', 'Номер счёта' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_AccountNumber');

CREATE OR REPLACE FUNCTION zc_MovementString_ConfirmationCodeSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_ConfirmationCodeSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_ConfirmationCodeSP', 'код подтверждения рецепта (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_ConfirmationCodeSP');

CREATE OR REPLACE FUNCTION zc_MovementString_Function() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Function'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Function', 'Функция получения текст сообщения' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Function');

CREATE OR REPLACE FUNCTION zc_MovementString_Form() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Form'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Form', 'Имя формы' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Form');

CREATE OR REPLACE FUNCTION zc_MovementString_Title() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Title'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Title', 'Название' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Title');

CREATE OR REPLACE FUNCTION zc_MovementString_BookingId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BookingId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BookingId', 'Номер заказа' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BookingId');

CREATE OR REPLACE FUNCTION zc_MovementString_OrderId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_OrderId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_OrderId', 'ID заказа в системе источника' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_OrderId');

CREATE OR REPLACE FUNCTION zc_MovementString_BookingStatus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BookingStatus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BookingStatus', 'Статус заказа' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BookingStatus');

CREATE OR REPLACE FUNCTION zc_MovementString_LetterSubject() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_LetterSubject'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_LetterSubject', 'Тема письма' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_LetterSubject');

CREATE OR REPLACE FUNCTION zc_MovementString_CommentMarketing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentMarketing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CommentMarketing', 'Комментарий маркетинга' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentMarketing');

CREATE OR REPLACE FUNCTION zc_MovementString_CommentChecking() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentChecking'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CommentChecking', 'Примечание для проверяющей' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentChecking');

CREATE OR REPLACE FUNCTION zc_MovementString_CommentCustomer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentCustomer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CommentCustomer', 'Комментарий клиента' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CommentCustomer');

CREATE OR REPLACE FUNCTION zc_MovementString_ReportNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_ReportNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_ReportNumber', 'Номер отчета' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_ReportNumber');

CREATE OR REPLACE FUNCTION zc_MovementString_SiteWhoUpdate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_SiteWhoUpdate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_SiteWhoUpdate', 'Кто изменил на сайте' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_SiteWhoUpdate');

CREATE OR REPLACE FUNCTION zc_MovementString_ActNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_ActNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_ActNumber', 'Номер акта' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_ActNumber');

CREATE OR REPLACE FUNCTION zc_MovementString_DealId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_DealId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_DealId', 'Внутрішній DealId замовлення Вчасно-EDI' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_DealId');
  
CREATE OR REPLACE FUNCTION zc_MovementString_DocumentId_vch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_DocumentId_vch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_DocumentId_vch', 'Внутрішній DocumentId Вчасно-EDI' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_DocumentId_vch');

CREATE OR REPLACE FUNCTION zc_MovementString_VchasnoId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_VchasnoId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_VchasnoId', 'Внутрішній VchasnoId Вчасно-EDI' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_VchasnoId');

CREATE OR REPLACE FUNCTION zc_MovementString_Uuid() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Uuid'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Uuid', 'Ідентифікатор документа, у «Електронної товарно-транспортної накладної» (е-ТТН)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Uuid');

CREATE OR REPLACE FUNCTION zc_MovementString_RRN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_RRN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_RRN', 'RRN уникальный номер транзакции' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_RRN');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 04.08.23                                                                      * zc_MovementString_RRN
 02.05.23                                                                      * zc_MovementString_Uuid
 23.03.23                                                                      * zc_MovementString_DealId
 14.03.23                                                                      * zc_MovementString_ActNumber
 04.10.22                                                                      * zc_MovementString_SiteWhoUpdate
 07.05.22                                                                      * zc_MovementString_ReportNumber
 23.09.21                                                                      * zc_MovementString_CommentCustomer
 06.09.21                                                                      * zc_MovementString_CommentChecking
 26.04.21         * zc_MovementString_CommentStop
 15.02.21                                                                      * zc_MovementString_CommentMarketing
 25.06.20                                                                      * zc_MovementString_LetterSubject
 23.06.20                                                                      * zc_MovementString_BookingStatus
 16.06.20                                                                      * zc_MovementString_BookingId, zc_MovementString_OrderId
 17.05.20                                                                      * zc_MovementString_Form
 12.05.20                                                                      * zc_MovementString_Title
 19.02.20                                                                      * zc_MovementString_Function
 17.05.19                                                                      * zc_MovementString_ConfirmationCodeSP
 01.10.18                                                                      * zc_MovementString_AccountNumber
 07.04.17         * zc_MovementString_Ambulance
 22.12.16         * zc_MovementString_MedicSP
                    zc_MovementString_InvNumberSP
 04.08.16         *
 30.07.14                         *
 19.07.14                                        * del zc_MovementString_SaleInvNumber
 17.06.14         * add zc_MovementString_InvNumberPartner()
                      , zc_MovementString_InvNumberMark()
 24.04.14                                                       * add zc_MovementString_InvNumberBranch
 23.04.14                                        * add zc_MovementString_InvNumberMark
 11.01.14                                        * add zc_MovementString_InvNumberOrder
 02.12.13                         * поля для работы с Клиент-Банком
 25.09.13         * add zc_MovementString_Comment
 13.08.13         * add zc_MovementString_OKPO
 12.08.13         * add zc_MovementString_FileName
 19.07.13         * add zc_MovementString_PartionGoods()
 30.06.13                                        * НОВАЯ СХЕМА
*/
