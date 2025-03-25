type
  TThema = class(TObject)
    Caption: String;
    TopicLevel: Integer;
    TopicID: String;
  end;

var
  ThemenListe: TStringList;
  Thema: TThema;
  i: Integer;
  ParentIDs: array[0..10] of String;
begin
  ThemenListe := TStringList.Create;
  try
    // Thema 1: Lizenz - Bitte lesen !!!
    Thema := TThema.Create;
    Thema.Caption := 'Lizenz - Bitte lesen !!!';
    Thema.TopicLevel := 0;
    ThemenListe.AddObject('Thema0', Thema);
    // Thema 2: Überblich
    Thema := TThema.Create;
    Thema.Caption := 'Überblich';
    Thema.TopicLevel := 1;
    ThemenListe.AddObject('Thema1', Thema);
    // Thema 3: Inhalt
    Thema := TThema.Create;
    Thema.Caption := 'Inhalt';
    Thema.TopicLevel := 0;
    ThemenListe.AddObject('Thema2', Thema);
    // Thema 4: Liste der Tabellen
    Thema := TThema.Create;
    Thema.Caption := 'Liste der Tabellen';
    Thema.TopicLevel := 1;
    ThemenListe.AddObject('Thema3', Thema);
    // Thema 5: Über dieses Handbuch
    Thema := TThema.Create;
    Thema.Caption := 'Über dieses Handbuch';
    Thema.TopicLevel := 1;
    ThemenListe.AddObject('Thema4', Thema);

    // Jetzt alle Themen mit richtiger Hierarchie erzeugen
    for i := 0 to ThemenListe.Count - 1 do
    begin
      Thema := TThema(ThemenListe.Objects[i]);
      if Thema.TopicLevel = 0 then
        Thema.TopicID := HndTopics.CreateTopic('')
      else
        Thema.TopicID := HndTopics.CreateTopic(ParentIDs[Thema.TopicLevel - 1]);
      HndTopics.SetTopicCaption(Thema.TopicID, Thema.Caption);
      ParentIDs[Thema.TopicLevel] := Thema.TopicID;
    end;
  finally
    for i := 0 to ThemenListe.Count - 1 do
      TThema(ThemenListe.Objects[i]).Free;
    ThemenListe.Free;
  end;
end.