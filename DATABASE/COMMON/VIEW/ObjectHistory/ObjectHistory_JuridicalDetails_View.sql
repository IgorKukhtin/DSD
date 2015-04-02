-- View: ObjectHistory_JuridicalDetails_View

CREATE OR REPLACE VIEW ObjectHistory_JuridicalDetails_View AS
  SELECT ObjectHistory_JuridicalDetails.Id AS ObjectHistoryId
       , ObjectHistory_JuridicalDetails.ObjectId AS JuridicalId
       , ObjectHistoryString_OKPO.ValueData AS OKPO
       , ObjectHistoryString_INN.ValueData AS INN
  FROM ObjectHistory AS ObjectHistory_JuridicalDetails
       LEFT JOIN ObjectHistoryString AS ObjectHistoryString_OKPO
                                     ON ObjectHistoryString_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                    AND ObjectHistoryString_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
       LEFT JOIN ObjectHistoryString AS ObjectHistoryString_INN
                                     ON ObjectHistoryString_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                    AND ObjectHistoryString_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()
  WHERE ObjectHistory_JuridicalDetails.DescId = zc_ObjectHistory_JuridicalDetails()
    AND ObjectHistory_JuridicalDetails.EndDate = zc_DateEnd()
    -- AND ObjectHistory_JuridicalDetails.EndDate >= '01.01.2020'
 ;


ALTER TABLE ObjectHistory_JuridicalDetails_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.15                                        *
 28.12.13                                        *
*/

-- тест
-- SELECT * FROM ObjectHistory_JuridicalDetails_View
