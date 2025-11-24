from django.db import models

class Player(models.Model):
    id = models.CharField(max_length=32, primary_key=True)
    name = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.name} ({self.id})"


class LevelStat(models.Model):
    player = models.ForeignKey(Player, related_name='levels', on_delete=models.CASCADE)
    lvl_id = models.IntegerField()
    attempts = models.IntegerField(default=0)
    best_time = models.FloatField(null=True, blank=True)
    coins = models.IntegerField(default=0)

    class Meta:
        unique_together = ('player', 'lvl_id')
        indexes = [
            models.Index(fields=['lvl_id']),
            models.Index(fields=['best_time']),
        ]

    def __str__(self):
        return f"P:{self.player_id} L:{self.lvl_id} time:{self.best_time}"
