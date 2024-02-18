<template>
  <div
    id="sidenav-collapse-main"
    class="w-auto h-auto collapse navbar-collapse max-height-vh-100 h-100"
  >
    <ul class="navbar-nav">
      <li class="nav-item">
        <sidenav-collapse nav-text="Dashboard" :to="{ name: 'Dashboard' }">
          <template #icon>
            <icon name="spaceship" />
          </template>
        </sidenav-collapse>
      </li>
      <li class="nav-item">
        <sidenav-collapse nav-text="Blind Loan Requests" :to="{ name: 'Requests' }">
          <template #icon>
            <icon name="shop" />
          </template>
        </sidenav-collapse>
      </li>
      <li class="nav-item">
        <sidenav-collapse nav-text="Blind Loan Offers" :to="{ name: 'Offers' }">
          <template #icon>
            <icon name="office" />
          </template>
        </sidenav-collapse>
      </li>
      <li class="nav-item">
        <sidenav-collapse nav-text="Blind Loans" :to="{ name: 'Loans' }">
          <template #icon>
            <icon name="document" />
          </template>
        </sidenav-collapse>
      </li>
      <li class="nav-item">
        <sidenav-collapse nav-text="Tables" :to="{ name: 'Tables' }">
          <template #icon>
            <icon name="tables" />
          </template>
        </sidenav-collapse>
      </li>

    </ul>
  </div>
  <div class="pt-3 mx-3 mt-3 sidenav-footer">

  </div>
</template>
<script>
import Icon from "@/components/Icon.vue";
import SidenavCollapse from "./SidenavCollapse.vue";
import SidenavCard from "./SidenavCard.vue";

export default {
  name: "SidenavList",
  components: {
    Icon,
    SidenavCollapse,
    SidenavCard,
  },
  props: {
    cardBg: {
      type: String,
      default: ""
    },
  },
  data() {
    return {
      title: "3 Blind Deeds",
      controls: "dashboardsExamples",
      isActive: "active",
    };
  },
  methods: {
    getRoute() {
      const routeArr = this.$route.path.split("/");
      return routeArr[1];
    },
  },
};
</script>
