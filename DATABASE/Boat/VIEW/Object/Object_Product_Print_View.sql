-- View: Object_Product_PrintInfo_View

-- DROP VIEW IF EXISTS Object_Product_PrintInfo_View;

CREATE OR REPLACE VIEW Object_Product_PrintInfo_View AS
   SELECT 'info@agilis-jettenders.com' ::TVarChar AS Mail
        , 'www.agilis-jettenders.com'  ::TVarChar AS WWW
        , 'Agilis Jettenders GmbH'     ::TVarChar AS Name_main
        , 'Lohfeld Str. 2'             ::TVarChar AS Street_main
        , '52428 Julich'               ::TVarChar AS City_main                                   --*
        , 'Adriatic Wave d.o.o'        ::TVarChar AS Name_Firma
        , 'Via Niccoloa Tommasea 11'   ::TVarChar AS Street_Firma
        , '52210 ROVINJ'               ::TVarChar AS City_Firma
        , 'KROATIEN'                   ::TVarChar AS Country_Firma
        , 'steuerfreie innergem. Lieferung gemab §4 Nr.1b i.V.m. §6a UStG' ::TVarChar AS Text_tax   --** не облагаемый налогом внутренний Поставка в соответствии с §4 № 1b в сочетании с §6a UStG. 
        , 'special discount'                    ::TVarChar AS Text_discount
        , 'Sie wurden beraten von M.Starchenko' ::TVarChar AS Text_sign

        , 'Fapi Motor Ltd'        ::TVarChar AS Name_Firma2
        , 'Pitkali road'          ::TVarChar AS Street_Firma2
        , 'ATD 2214 ATTARD'       ::TVarChar AS City_Firma2
        , 'MALTA'                 ::TVarChar AS Country_Firma2
        , '(taxfree intra-Community supply of goods according to §4 Nr.1b and §6a UStG.)' ::TVarChar AS Text_tax2   --**
        , 'Freight charge'                    ::TVarChar AS Text_Freight            --Плата за фрахт      

        , 'Agilis Jettenders GmbH'||Chr(13)||Chr(10)||'Lohfeld Str.2'||Chr(13)||Chr(10)||' 52428 Julich' ::TVarChar AS Footer1              --*
        , 'Bankverbindung'||Chr(13)||Chr(10)||'Aachener Bank eG'||Chr(13)||Chr(10)||'IBAN: DE56390601800154560009'||Chr(13)||Chr(10)||'BIC: GENODED1AAC' ::TVarChar AS Footer2
        , 'Geschaftsfuhrer:Starchenko Maxym'||Chr(13)||Chr(10)||Chr(13)||Chr(10)||'Amtsgericht Duren HRB 8163'||Chr(13)||Chr(10)||'Ust.-ID: DE326730388' ::TVarChar AS Footer3   --***
        , 'Tel: +49 (0)2461 340 333-15'||Chr(13)||Chr(10)||'Fax: +49 (0)2461 340 333 13'||Chr(13)||Chr(10)||'Email: info@agilis-jettenders.com'||Chr(13)||Chr(10)||'WEB: www.agilis-jettenders.com' ::TVarChar AS Footer4
            
   ;


ALTER TABLE Object_Product_PrintInfo_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 2.03.21          *
*/

-- тест
-- SELECT * FROM Object_Product_PrintInfo_View
