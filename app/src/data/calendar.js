export default {
    dayNames: ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"],
    monthShortNames: ["janv.", "févr.", "mars", "avr.", "mai", "juin", "juill.", "août", "sept.", "oct.", "nov.", "déc."],
    monthNames: ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"],

    getMonthKey: (date) => {
        return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, 0)}`
    },

    getDateKey: (date) => {
        return `${this.getMonthKey(date)}-${date.getDate().toString().padStart(2, 0)}`
    }
}