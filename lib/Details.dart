class Details {
  final String userName;
  final int contributors;
  final int commits;
  final int watchers;

  final String title;
  final String description;

  Repo(this.userName, this.stars, this.watchers, this.forks, this.title, this.description);

  static List<Repo> fromJson(List<dynamic> json) {
    return json.map((item) => Repo(
        item['owner']["login"],
        item['stargazers_count'],
        item['watchers_count'],
        item['forks_count'],
        item['name'],
        item['description']
    )).toList();
  }
}