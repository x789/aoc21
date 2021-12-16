# Advent of Code: Day #6 - Lanternfish
# (c) 2021 TillW

class Swarm:
    def __init__(self, population):
        self.cohorts = [0] * 9
        for i in population:
            self.cohorts[int(i)] += 1

    def getPopulationCount(self):
        sum = 0
        for i in range(len(self.cohorts)):
            sum += self.cohorts[i]
        return sum

    def ageByOneDay(self):
        yesterday = self.cohorts
        self.cohorts = [0] * 9
        for i in range(len(yesterday)):
            self.cohorts[i % 9] = yesterday[(i+1)%9]
        self.cohorts[6] += yesterday[0] # add the mommies

initialPopulation = "3,4,3,1,2"
days = 80
fishs = []

swarm = Swarm(initialPopulation.split(","))

for day in range(days):
    swarm.ageByOneDay()

print("Number of Lanternfishs after {} days: {}".format(days, swarm.getPopulationCount()))