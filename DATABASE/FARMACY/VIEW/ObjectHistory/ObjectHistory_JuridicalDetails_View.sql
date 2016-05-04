-- View: ObjectHistory_JuridicalDetails_View

DROP VIEW IF EXISTS ObjectHistory_JuridicalDetails_View;

CREATE OR REPLACE VIEW ObjectHistory_JuridicalDetails_View AS
  SELECT objecthistory_juridicaldetails.id AS objecthistoryid,
    objecthistory_juridicaldetails.objectid AS juridicalid,
    objecthistorystring_okpo.valuedata AS okpo,
    objecthistorystring_inn.valuedata AS inn
   FROM objecthistory objecthistory_juridicaldetails
     LEFT JOIN objecthistorystring objecthistorystring_okpo ON objecthistorystring_okpo.objecthistoryid = objecthistory_juridicaldetails.id AND objecthistorystring_okpo.descid = zc_objecthistorystring_juridicaldetails_okpo()
     LEFT JOIN objecthistorystring objecthistorystring_inn ON objecthistorystring_inn.objecthistoryid = objecthistory_juridicaldetails.id AND objecthistorystring_inn.descid = zc_objecthistorystring_juridicaldetails_inn()
  WHERE objecthistory_juridicaldetails.descid = zc_objecthistory_juridicaldetails() AND objecthistory_juridicaldetails.enddate::timestamp with time zone = zc_dateend()::timestamp with time zone
 ;


ALTER TABLE ObjectHistory_JuridicalDetails_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.01.15                       *
*/

-- тест
-- SELECT * FROM ObjectHistory_JuridicalDetails_View
