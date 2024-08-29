-- View: Object_Product_PrintInfo_View

DROP VIEW IF EXISTS Object_Product_PrintInfo_View;

CREATE OR REPLACE VIEW Object_Product_PrintInfo_View
AS
   SELECT 'info@agilis-jettenders.com' ::TVarChar AS Mail
        , 'www.agilis-jettenders.com'  ::TVarChar AS WWW

        , 'Agilis Jettenders GmbH'     ::TVarChar AS Name_main
        , 'Lohfeld Str. 2'             ::TVarChar AS Street_main
        , '52428 Julich'               ::TVarChar AS City_main                                   --*
        , 'Germany'                    ::TVarChar AS Country_main

        , 'Name_Firma'        ::TVarChar AS Name_Firma -- Adriatic Wave d.o.o
        , 'Street_Firma'   ::TVarChar AS Street_Firma -- Via Niccoloa Tommasea 11
        , 'City_Firma'               ::TVarChar AS City_Firma -- 52210 ROVINJ
        , 'Country_Firma'                    ::TVarChar AS Country_Firma -- Germany
        , 'Text_tax' ::TVarChar AS Text_tax -- steuerfreie innergem. Lieferung gemab §4 Nr.1b i.V.m. §6a UStG   --** не облагаемый налогом внутренний Поставка в соответствии с §4 № 1b в сочетании с §6a UStG.
        , 'Text_discount'                    ::TVarChar AS Text_discount -- special discount
           -- !!!!
        , 'Sie wurden beraten von ' ::TVarChar AS Text_sign

        , 'Name_Firma2'        ::TVarChar AS Name_Firma2 -- Fapi Motor Ltd
        , 'Street_Firma2'          ::TVarChar AS Street_Firma2 -- Pitkali road
        , 'City_Firma2'       ::TVarChar AS City_Firma2 -- ATD 2214 ATTARD
        , 'Country_Firma2'                 ::TVarChar AS Country_Firma2 -- MALTA
        , 'Text_tax2' ::TVarChar AS Text_tax2   -- (taxfree intra-Community supply of goods according to §4 Nr.1b and §6a UStG.)
           -- !!!!
        , 'Freight charge'                    ::TVarChar AS Text_Freight            --Плата за фрахт

        , 'Agilis Jettenders GmbH'||Chr(13)||Chr(10)||'Lohfeld Str.2'||Chr(13)||Chr(10)||' 52428 Julich' ::TVarChar AS Footer1              --*

--      , 'Bankverbindung'||Chr(13)||Chr(10)||'Aachener Bank eG'||Chr(13)||Chr(10)||'IBAN: DE56390601800154560009'||Chr(13)||Chr(10)||'BIC: GENODED1AAC' ::TVarChar AS Footer2
        , 'Bankverbindung'||Chr(13)||Chr(10)||'WISE EUROPE S.A'||Chr(13)||Chr(10)||'IBAN: BE41 9678 8213 2110'||Chr(13)||Chr(10)||'BIC: TRWIBEB1XXX' ::TVarChar AS Footer2

        , 'Geschaftsfuhrer:Starchenko Maxym'||Chr(13)||Chr(10)||Chr(13)||Chr(10)||'Amtsgericht Duren HRB 8163'||Chr(13)||Chr(10)||'Ust.-ID: DE326730388' ::TVarChar AS Footer3   --***

        , 'Tel: +49 (0)2461 340 333-15'||Chr(13)||Chr(10)||'Fax: +49 (0)2461 340 333 13'||Chr(13)||Chr(10)||'Email: info@agilis-jettenders.com'||Chr(13)||Chr(10)||'WEB: www.agilis-jettenders.com' ::TVarChar AS Footer4

--      , 'BANKKONTO: Aachener Bank eG'||Chr(13)||Chr(10)||'IBAN: DE56390601800154560009'||Chr(10)||'SWIFT: GENODED1AAC' ::TVarChar AS Footer_bank
        , 'BANKKONTO: WISE EUROPE S.A'||Chr(13)||Chr(10)||'IBAN: BE41 9678 8213 2110'||Chr(10)||'SWIFT: TRWIBEB1XXX' ::TVarChar AS Footer_bank

        , 'CEO: STARCHENKO MAXYM, REGISTERGERICHT: DUREN HRB 8163, UMSATZSTEUERGESETZ: DE326730388' ::TVarChar AS Footer_user
   ;


ALTER TABLE Object_Product_PrintInfo_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
11.12.23          *
 2.03.21          *
*/

-- тест
-- SELECT * FROM Object_Product_PrintInfo_View
