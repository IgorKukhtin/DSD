INSERT INTO ObjectBooleanDesc (id, DescId, Code ,itemname)
SELECT zc_ObjectBoolean_Juridical_isCorporate(), zc_Object_Juridical(), 'Juridical_isCorporate','Признак наша ли собственность это юридическое лицо'  WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Id = zc_ObjectBoolean_Juridical_isCorporate());


--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.13                                        * НОВАЯ СХЕМА
*/
