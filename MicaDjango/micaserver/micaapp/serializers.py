from rest_framework import serializers
from .models import Player, LevelStat

class LevelStatSerializer(serializers.ModelSerializer):
    class Meta:
        model = LevelStat
        fields = ['lvl_id', 'attempts', 'best_time', 'coins']

class PlayerSerializer(serializers.ModelSerializer):
    levels = LevelStatSerializer(many=True)

    class Meta:
        model = Player
        fields = ['id', 'name', 'levels']

    def create(self, validated_data):
        levels_data = validated_data.pop('levels', [])
        player = Player.objects.create(**validated_data)
        for level_data in levels_data:
            LevelStat.objects.create(player=player, **level_data)
        return player

    def update(self, instance, validated_data):
        levels_data = validated_data.pop('levels', [])
        instance.name = validated_data.get('name', instance.name)
        instance.save()

        for level_data in levels_data:
            level_obj, created = LevelStat.objects.update_or_create(
                player=instance,
                lvl_id=level_data['lvl_id'],
                defaults={
                    'attempts': level_data.get('attempts', 0),
                    'best_time': level_data.get('best_time'),
                    'coins': level_data.get('coins', 0),
                }
            )
        return instance
