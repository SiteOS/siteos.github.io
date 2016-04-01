---
layout: post
author: Alexander Bischof
authorkey: alexanderbischof
title: "In welchen Exporten war ich eigentlich?"
description: "Einfaches Auffinden von Daten in Exportlisten mittels Git/JGit"
categories: Java Git JGit
---
Heutzutage dreht es sich in IT-Systemen nur noch um Daten. Wo kommen Sie her, wie und wo werden sie gespeichert, wo angezeigt und welche
nachgelagerten Prozessschritte existieren? Früher oder später werden sie jedoch exportiert und an dieser Stelle kann die Protokollierung
und Nachvollziehbarkeit eine große Rolle spielen (z.B. hinsichtlich Datenschutz). Dabei ist zu meist weniger relevant wer den Export durchgeführt hat,
sondern eher **In welchen Exporten war ein bestimmter Datensatz drin bzw. nicht drin?**.   
Dieser Artikel zeigt einen einfachen und meiner Meinung nach eleganten Weg, wie das mittels Git und Java/JGit (hier [JGit](https://eclipse.org/jgit/))
erreicht werden kann.

### Pure Git

Zunächst möchte ich die reine Kommandozeilen Variante vorstellen, wobei es an dieser Stelle nicht *den* richtigen Weg gibt, sondern man zwischen verschiedenen
Varianten wählen kann (z.B. git log, git grep, git rev-list). Der wohl einfachste Weg ist über *git rev-list* mit dem folgenden Kommando:

{% highlight text %}
bischofa$ git rev-list --all | xargs git grep ^5555$
e55a726d4a7b19dd3278746893268166a83ef77a:exportfile:5555
afb6d890e4c993d1751ff8d5fd553dab9b52ede4:exportfile:5555
{% endhighlight %}

Mittels obigen Snippet wird in allen Commits nach dem *regulären Ausdruck* **^5555$** gesucht und die entsprechenden Commits
ausgegeben. Diese könnte man nun sogar über weitere Skripte verarbeiten, um entsprechende Reports draus zu bauen.      
Sehr interessant in diesem Kontext sind auch weitere Parameter mit dem man die Commit-Filterung erweitern kann, wie z.B.:

 - *--skip*
 - *--max-count*
 - *--date*

### JGit

Nun kam ich an den Punkt, wo ich obige Funktionalität in Java verwenden wollte und fand folgenden
 [Stackoverflow-Artikel](http://stackoverflow.com/questions/15572483/how-to-do-git-grep-e-pattern-with-jgit), der ein
 *git grep* mittels *JGit* beinhaltet.    
  Im folgenden Code-Snippet wurde der Code aus dem Artikel leicht verändert (z.B. Java 8), so dass man direkt an die Commit-Information
  herankommt und diese auch zurückgeliefert werden.

{% highlight java %}
private List<String> walk(ObjectReader objectReader, RevCommit revCommit) {
    try {
        TreeWalk treeWalk = new TreeWalk(objectReader);

        CanonicalTreeParser treeParser = new CanonicalTreeParser();
        treeParser.reset(objectReader, revCommit.getTree());
        int treeIndex = treeWalk.addTree(treeParser);
        treeWalk.setRecursive(true);

        while (treeWalk.next()) {
            AbstractTreeIterator it = treeWalk.getTree(treeIndex, AbstractTreeIterator.class);
            ObjectId objectId = it.getEntryObjectId();
            ObjectLoader objectLoader = objectReader.open(objectId);

            if (!isBinary(objectLoader.openStream())) {
                List<String> matchedLines = getMatchedLines(objectLoader.openStream());
                if (!matchedLines.isEmpty()) {
                    return matchedLines.stream()
                            .map(s -> revCommit.getAuthorIdent() + " " + revCommit.getFullMessage() + ":" + s)
                            .collect(toList());
                }
            }
        }
    } catch (Exception e) {
        throw new RuntimeException(e);
    }
    return emptyList();
}
{% endhighlight %}

### Beispiel

Als kleines konsturiertes Beispiel zum Testen nehme man an, dass ein System Export-Dateien mit Nummern erzeugt und man möchte nun wissen
in welchen Exporten die Zahl 5555 drin war.   

Dazu habe ich eine JUnit4-Bootstrap-Rule gebaut, die mir ein paar Testdaten erzeugt und jeweils commited.

 - Commit 1: Zahlen von 0-100000
 - Commit 2: Zahlen von 0-110000 ohne 5000-5999
 - Commit 3: Zahlen von 10000-100000
 - Commit 4: Zahlen von 5000-6000
 - Commit 5: Zahlen von 0-1
 
{% highlight java %}
public class BootstrapRule implements TestRule {

    private Repository repository;

    public BootstrapRule() {
        try {
            repository = createNewRepository();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public Statement apply(Statement statement, Description description) {
        return new Statement() {
            @Override
            public void evaluate() throws Throwable {
                try (Git git = new Git(repository)) {
                    // create the file
                    File myfile = new File(repository.getDirectory().getParent(), "exportfile");
                    myfile.createNewFile();
                    myfile.deleteOnExit();

                    writeNumbersExportFile(git, myfile, 0, 100_000, null, "Adds 0 to 100_000");
                    writeNumbersExportFile(git, myfile, 0, 110_000, i -> i < 5_000 || i >= 6_000, "Adds 0 to 110_000 without 5_000s");
                    writeNumbersExportFile(git, myfile, 10_000, 100_000, null, "Adds 10_000 to 100_000");
                    writeNumbersExportFile(git, myfile, 5_000, 6_000, null, "Adds 5_000 to 6_000");
                    writeNumbersExportFile(git, myfile, 0, 1, null, "Adds 0 to 1");

                    statement.evaluate();
                } finally {
                    repository.getDirectory().deleteOnExit();
                    repository.close();
                }
            }
        };
    }
    ...snip
}
{% endhighlight %}

Über den regulären Ausdruck **^5555$** werden nun alle Commits durchlaufen und nach dem Ausdruck durchforstet.

{% highlight java %}
public class GitDiffTest {
    @ClassRule
    public static BootstrapRule bootstrapRule = new BootstrapRule();

    @Test
    public void test() throws IOException, GitAPIException {
        String searchString = "^5555$";

        Repository repository = bootstrapRule.getRepository();
        Grep grep = new Grep(repository, compile(searchString));
        assertThat(grep.grepPrintingResults()).hasSize(2);
    }
}
{% endhighlight %}

Die entsprechenden Source findet ihr in meinem [Github-Repo]([https://github.com/AlexBischof/gitreflisttest](https://github.com/AlexBischof/gitreflisttest))
 