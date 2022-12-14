<script>
import calendar from '../../data/calendar';

export default {
  data () {
    return {
      values: []
    }
  },

  computed: {
    orangeAlertsCount: function () {
      return this.values.filter(function (value) {
        return value.hvalue === 2;
      }).length;
    },

    redAlertsCount: function () {
      return this.values.filter(function (value) {
        return value.hvalue === 3;
      }).length;
    },
  },

  methods: {
    getClassName(hour, hvalue) {
      var className = "daysplit__item__square"
      if (hvalue === 3) {
        className += " daysplit__item__square--red"
      } else if (hvalue === 2) {
        className += " daysplit__item__square--orange"
      } else if (8 <= hour && hour < 13 || 18 <= hour && hour < 20) {
        className += " daysplit__item__square--dark"
      }
      return className;
    },

    getTitle(hour, hvalue) {
      const secondHour = (hour + 1) % 24;
      if (hvalue === 3) {
        return `Alerte rouge entre ${hour}h et ${secondHour}h.`
      } else if (hvalue === 2) {
        return `Alerte orange entre ${hour}h et ${secondHour}h.`
      } else if (8 <= hour && hour < 13 || 18 <= hour && hour < 20) {
        return `Période de forte consommation entre ${hour}h et ${secondHour}h.`
      } else {
        return `Consommation normale entre ${hour}h et ${secondHour}h.`
      }
    },

    updateStorageAlertsCount () {
      chrome.storage.local.get("months", function (data) {
        var now = new Date(),
          monthKey = `${now.getFullYear()}-${(now.getMonth() + 1).toString().padStart(2, 0)}`,
          dayKey = `${monthKey}-${now.getDate().toString().padStart(2, 0)}`;

        var monthsData = data.months || {};

        monthsData[monthKey] = monthsData[monthKey] || {
          label: {
            month: calendar.monthNames[now.getMonth()],
            year: now.getFullYear().toString()
          },
          score: 0,
          alerts: { red: 0, orange: 0 },
          days: {}
        }

        monthsData[monthKey].days[dayKey] = monthsData[monthKey].days[dayKey] || {
          alerts: { red: 0, orange: 0 },
          ecogestes: {},
          score: 0
        };

        monthsData[monthKey].days[dayKey].alerts.orange = this.orangeAlertsCount;
        monthsData[monthKey].days[dayKey].alerts.red = this.redAlertsCount;

        monthsData[monthKey].alerts.red = Object.values(monthsData[monthKey].days).reduce((a, b) => a + b.alerts.red, 0);
        monthsData[monthKey].alerts.orange = Object.values(monthsData[monthKey].days).reduce((a, b) => a + b.alerts.orange, 0);

        chrome.storage.local.set({ months: monthsData });
      }.bind(this));
    }
  },

  mounted () {
    chrome.storage.local.get("signals", function (data) {
      const now = new Date(),
        isoDate = `${now.getFullYear()}-${(now.getMonth() + 1).toString().padStart(2, 0)}-${now.getDate().toString().padStart(2, 0)}`;

      const currentDay = data.signals.signals.find(item => {
        return item.jour.indexOf(isoDate) !== -1;
      });

      if (currentDay) {
        this.values = currentDay.values;
        this.updateStorageAlertsCount();
      }
    }.bind(this));
  }
}
</script>

<template>
  <p class="fr-mb-1w fr-mt-8v fr-text--sm">Alertes prévues aujourd'hui</p>

  <div class="daysplit__legend">
    <div class="daysplit__legend__item fr-text--xs fr-mb-1w">
      <span class="daysplit__legend__square daysplit__legend__square--high"></span>
      Forte consommation
    </div>
    <div class="legend__item fr-text--xs fr-mb-1w">
      <span class="daysplit__legend__square daysplit__legend__square--regular"></span>
      Consommation normale
    </div>
  </div>

  <div class="fr-grid-row daysplit">
    <div class="fr-col daysplit__item" v-for="value in values">
      <div :class="getClassName(value.pas, value.hvalue)" :title="getTitle(value.pas, value.hvalue)"></div>
      <p class="fr-text--xs fr-mb-1w" v-if="value.pas % 2 === 0">{{ value.pas }}h</p>
    </div>
  </div>
  <div class="fr-grid-row fr-grid-row--gutters">
    <div class="fr-col">
      <div :class="{ 'is-inactive': redAlertsCount === 0 }" class="fr-alert fr-alert--error">
        <div class="fr-alert__count" v-if="redAlertsCount > 0">{{ redAlertsCount }}</div>
        <p class="fr-text--sm fr-mb-0" v-if="redAlertsCount > 0">Alerte(s) rouge(s) : coupures inévitables si la consommation n’est pas réduite.</p>
        <p class="fr-text--sm fr-mb-0" v-if="redAlertsCount === 0">Pas d'alerte rouge prévue</p>
      </div>
    </div>
    <div class="fr-col">
      <div :class="{ 'is-inactive': orangeAlertsCount === 0 }" class="fr-alert fr-alert--warning">
        <div class="fr-alert__count" v-if="orangeAlertsCount > 0">{{ orangeAlertsCount }}</div>
        <p class="fr-text--sm fr-mb-0" v-if="orangeAlertsCount > 0">Alerte(s) orange(s) : la réduction et le décalage des consommations d’énergie sont nécessaires.</p>
        <p class="fr-text--sm fr-mb-0" v-if="orangeAlertsCount === 0">Pas d'alerte orange prévue</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.fr-alert__count {
  bottom: 0;
  color: white;
  font-weight: bold;
  left: 0;
  margin: 0.5rem .5rem;
  position: absolute;
  text-align: center;
  width: 1.5rem;
}

.daysplit {
  margin: -0.05rem;
}

.daysplit__item {
  padding: 0 0.05rem;
}

.daysplit__item__square {
  background: var(--blue-france-850-200);
  height: 24px;
  width: 100%;
}

.daysplit__item__square--dark {
  background: var(--blue-france-main-525);
}

.daysplit__item__square--orange {
  background: #F69051;
}

.daysplit__item__square--red {
  background: var(--red-marianne-425-625-hover);
}

.daysplit__legend {
  display: flex;
  font-size: 0.85rem;
  margin: 0 -1rem 0.5rem;
}

.daysplit__legend__item {
  margin: 0 1rem;
}

.daysplit__legend__square {
  display: inline-block;
  height: 1rem;
  width: 1rem;
  vertical-align: middle;
}

.daysplit__legend__square--regular {
  background: #CACAFB;
}

.daysplit__legend__square--high {
  background: #6A6AF4;
}
</style>
